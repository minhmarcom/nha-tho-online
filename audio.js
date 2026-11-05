/*
 * BỘ ÂM THANH THÁNH ĐƯỜNG (WebAudio & Audio API)
 * Tổng hợp tiếng chuông nhà thờ, đàn organ, tiếng thắp nến, lần chuỗi hạt Mân Côi
 */
(() => {
  'use strict';

  let ac = null;
  let master = null;
  let isMuted = false;
  let musicAudio = null;
  let musicEnabled = true;

  function getContext() {
    if (!ac) {
      ac = new (window.AudioContext || window.webkitAudioContext)();
      master = ac.createGain();
      master.gain.value = 0.85;
      master.connect(ac.destination);
    }
    if (ac.state === 'suspended') ac.resume().catch(() => {});
    return ac;
  }

  function osc(type, freq, t, dur, gainVal, dest, opt = {}) {
    const o = ac.createOscillator();
    o.type = type;
    o.frequency.setValueAtTime(freq, t);
    if (opt.to) o.frequency.exponentialRampToValueAtTime(opt.to, t + dur);
    const g = ac.createGain();
    g.gain.setValueAtTime(0.0001, t);
    g.gain.exponentialRampToValueAtTime(gainVal, t + (opt.a || 0.01));
    g.gain.setValueAtTime(gainVal, t + dur * 0.6);
    g.gain.exponentialRampToValueAtTime(0.0001, t + dur);
    o.connect(g).connect(dest);
    o.start(t);
    o.stop(t + dur + 0.1);
  }

  const Sound = {
    // Tiếng chuông nhà thờ (Angelus Bell)
    churchBell(times = 1) {
      if (isMuted) return;
      const ctx = getContext();
      const t = ctx.currentTime;
      for (let i = 0; i < times; i++) {
        const s = t + i * 1.6;
        [329.63, 659.25, 987.77, 1318.5, 1760].forEach((f, idx) => {
          const gain = [0.4, 0.3, 0.2, 0.12, 0.06][idx];
          const dur = [4.5, 3.8, 3.0, 2.2, 1.5][idx];
          osc('sine', f, s, dur, gain, master, { a: 0.005 });
          osc('triangle', f * 0.5, s, 4.8, 0.25, master, { a: 0.01 });
        });
      }
    },

    // Đàn Organ Thánh ca (Majestic Pipe Organ chord)
    organ() {
      if (isMuted) return;
      const ctx = getContext();
      const t = ctx.currentTime;
      // D major majestic chord (D3, A3, D4, F#4, A4, D5)
      [146.83, 220.00, 293.66, 369.99, 440.00, 587.33].forEach((f) => {
        osc('sawtooth', f, t, 3.4, 0.1, master, { a: 0.15 });
        osc('triangle', f * 2, t, 3.2, 0.06, master, { a: 0.18 });
      });
    },

    // Tiếng thắp nến nhẹ nhàng
    candle() {
      if (isMuted) return;
      const ctx = getContext();
      const t = ctx.currentTime;
      osc('sine', 1200, t, 0.4, 0.15, master, { to: 800, a: 0.01 });
      osc('triangle', 600, t + 0.05, 0.6, 0.12, master, { a: 0.02 });
    },

    // Tiếng chuỗi hạt Mân Côi (Rosary bead click / chime)
    beadClick() {
      if (isMuted) return;
      const ctx = getContext();
      const t = ctx.currentTime;
      osc('sine', 1480, t, 0.22, 0.18, master, { to: 1200, a: 0.005 });
      osc('sine', 2960, t, 0.12, 0.08, master, { a: 0.005 });
    },

    // Tiếng chuông nhỏ kết thúc chuỗi kinh
    amenChime() {
      if (isMuted) return;
      const ctx = getContext();
      const t = ctx.currentTime;
      [587.33, 739.99, 880.00, 1174.66].forEach((f, idx) => {
        osc('sine', f, t + idx * 0.12, 2.5, 0.18, master, { a: 0.01 });
      });
    },

    // Bật/tắt nhạc nền Thánh ca
    toggleMusic(enable) {
      musicEnabled = typeof enable === 'boolean' ? enable : !musicEnabled;
      if (!musicAudio) {
        musicAudio = new Audio('assets/church_music1.mp3');
        musicAudio.loop = true;
        musicAudio.volume = 0.35;
      }
      if (musicEnabled && !isMuted) {
        musicAudio.play().catch(() => {});
      } else {
        musicAudio.pause();
      }
      return musicEnabled;
    },

    toggleMute() {
      isMuted = !isMuted;
      if (musicAudio) {
        if (isMuted) musicAudio.pause();
        else if (musicEnabled) musicAudio.play().catch(() => {});
      }
      return isMuted;
    },

    isMuted: () => isMuted,
    isMusicOn: () => musicEnabled
  };

  window.ChurchAudio = Sound;
})();
