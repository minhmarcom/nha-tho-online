/*
 * LOGIC GAME THÁNH ĐƯỜNG ONLINE (Amen, Tạ Ơn Chúa)
 * Mô phỏng không gian nhà thờ tương tác: di chuyển, quỳ cầu nguyện, thắp nến, dâng hoa, chuông giáo đường
 */
(() => {
  'use strict';

  const W = 1080;
  const H = 1920;
  const AISLE_X = 540;

  // Ảnh tài nguyên
  const IMG = {};
  [
    'church_altar', 'church_tower',
    'c_priest', 'c_altar_server', 'c_eucharist', 'c_man', 'c_woman', 'c_granny', 'c_nun',
    'anim_man', 'anim_woman', 'anim_granny',
    'fx_cross', 'fx_dove', 'fx_candle', 'fx_rose', 'fx_church_bell', 'fx_halo', 'fx_petal'
  ].forEach((k) => {
    const im = new Image();
    const ext = k.startsWith('church_') ? '.jpg' : '.png';
    im.src = 'assets/' + k + ext;
    IMG[k] = im;
  });
  const ok = (im) => im && im.complete && im.naturalWidth > 0;

  const ANIM = {
    man: { fw: 212, fh: 300, seatH: 210 },
    woman: { fw: 212, fh: 300, seatH: 220 },
    granny: { fw: 195, fh: 300, seatH: 222 }
  };
  const TORSO = { man: 172, woman: 175, granny: 178 };
  const hasAnim = (skin) => ANIM[skin] && ok(IMG['anim_' + skin]);

  const scaleAt = (y) => Math.max(0.35, Math.min(1.15, 0.42 + (y - 1260) * 0.00115));
  const facesLeft = (x) => x > AISLE_X + 15;
  const rnd = (a, b) => a + Math.random() * (b - a);

  let canvas, ctx;
  let bgStyle = 'altar'; // 'altar' | 'tower'
  function getAltarY() { return bgStyle === 'altar' ? 980 : 1080; }
  function getSceneDY() { return bgStyle === 'altar' ? -120 : -40; }

  // Hàng ghế gỗ nhà thờ
  const PEW_ROWS = [
    [380, 1260, 110], [700, 1260, 110], [240, 1260, 105], [840, 1260, 105],
    [360, 1340, 130], [720, 1340, 130], [190, 1340, 125], [890, 1340, 125],
    [340, 1440, 155], [740, 1440, 155], [160, 1440, 150], [920, 1440, 150],
    [310, 1560, 190], [770, 1560, 190]
  ];

  // Người chơi và các giáo dân cùng hiệp thông
  let player = null;
  const npcs = [];
  const altarCandles = []; // Các ngọn nến đang thắp trên bàn thờ
  const effects = [];
  const petals = [];
  const doves = [];
  let lastTime = performance.now();

  // Khởi tạo game
  function init(cv) {
    canvas = cv;
    canvas.width = W;
    canvas.height = H;
    ctx = canvas.getContext('2d');

    // Tải dữ liệu người chơi từ LocalStorage
    const savedName = localStorage.getItem('nto_name') || 'Maria An';
    const savedSkin = localStorage.getItem('nto_skin') || 'woman';
    bgStyle = localStorage.getItem('nto_bg') || 'altar';

    player = {
      isPlayer: true,
      name: savedName,
      skin: savedSkin,
      x: 380, y: 1340,
      state: 'sit',
      frame: 7, ft: 0,
      path: [],
      fade: 1,
      bowStart: 0
    };

    // Tạo một số NPC giáo dân và lễ sinh để không gian luôn đông vui, ấm cúng
    const demoNPCs = [
      { name: 'Cha Giuse', skin: 'priest', x: 540, y: 960, state: 'sit' },
      { name: 'Lễ sinh Phêrô', skin: 'altar_server', x: 440, y: 990, state: 'sit' },
      { name: 'Sơ Anna', skin: 'nun', x: 240, y: 1260, state: 'sit' },
      { name: 'TNTT Gioan', skin: 'eucharist', x: 700, y: 1260, state: 'sit' },
      { name: 'Bác Têrêsa', skin: 'granny', x: 720, y: 1340, state: 'sit' },
      { name: 'Anh Phaolô', skin: 'man', x: 340, y: 1440, state: 'sit' }
    ];

    demoNPCs.forEach((npc) => {
      npcs.push({
        ...npc,
        frame: 7, ft: 0,
        path: [],
        fade: 1,
        bowStart: 0,
        nextBow: performance.now() + rnd(4000, 20000)
      });
    });

    // Thắp sẵn 3 ngọn nến bình an trên bàn thờ
    altarCandles.push(
      { name: 'Cầu bình an gia đình', x: 480, y: 930, t0: performance.now() },
      { name: 'Tạ ơn Chúa vì muôn ơn lành', x: 540, y: 920, t0: performance.now() },
      { name: 'Cầu sức khỏe cha mẹ', x: 600, y: 930, t0: performance.now() }
    );

    // Lắng nghe click / touch để di chuyển nhân vật
    canvas.addEventListener('click', onCanvasClick);
    canvas.addEventListener('touchstart', (e) => {
      if (e.touches.length > 0) {
        const touch = e.touches[0];
        const rect = canvas.getBoundingClientRect();
        const scaleX = W / rect.width;
        const scaleY = H / rect.height;
        movePlayerTo((touch.clientX - rect.left) * scaleX, (touch.clientY - rect.top) * scaleY);
      }
    });

    requestAnimationFrame(loop);
  }

  function onCanvasClick(e) {
    const rect = canvas.getBoundingClientRect();
    const scaleX = W / rect.width;
    const scaleY = H / rect.height;
    const clickX = (e.clientX - rect.left) * scaleX;
    const clickY = (e.clientY - rect.top) * scaleY;
    movePlayerTo(clickX, clickY);
  }

  // Điều khiển người chơi di chuyển
  function movePlayerTo(targetX, targetY) {
    if (!player) return;
    const clampedY = Math.max(980, Math.min(1750, targetY));
    const clampedX = Math.max(120, Math.min(960, targetX));

    // Đi qua lối đi chính giữa nhà thờ (Aisle)
    player.path = [
      { x: AISLE_X, y: player.y },
      { x: AISLE_X, y: clampedY },
      { x: clampedX, y: clampedY }
    ];
    player.state = 'walk';
    player.after = (clampedY < 1050) ? 'kneel' : 'sit';
  }

  // Thắp nến cầu nguyện
  function lightCandle(intention = 'Cầu bình an') {
    if (!player) return;
    // Bước lên trước bàn thờ
    const ay = getAltarY();
    player.path = [
      { x: AISLE_X, y: player.y },
      { x: AISLE_X, y: ay + 40 }
    ];
    player.state = 'walk';
    player.after = 'offer';

    setTimeout(() => {
      altarCandles.push({
        name: player.name + ': ' + intention,
        x: AISLE_X + rnd(-160, 160),
        y: ay - 30 + rnd(-15, 15),
        t0: performance.now()
      });
      effects.push({
        type: 'sprite', img: 'fx_candle', x: AISLE_X, y: ay - 40,
        s: 0.7, t0: performance.now(), dur: 3500, rise: 60, glow: true
      });
      window.ChurchAudio?.candle();
      burst(AISLE_X, ay - 40, '#fde68a', 15);
    }, 1500);
  }

  // Dâng hoa kính Đức Mẹ / Chúa
  function offerRose(intention = 'Tạ ơn Chúa') {
    if (!player) return;
    const ay = getAltarY();
    player.path = [
      { x: AISLE_X, y: player.y },
      { x: AISLE_X, y: ay + 40 }
    ];
    player.state = 'walk';
    player.after = 'offer';

    setTimeout(() => {
      effects.push({
        type: 'sprite', img: 'fx_rose', x: AISLE_X, y: ay - 50,
        s: 0.8, t0: performance.now(), dur: 4000, rise: 70, glow: true
      });
      petalBurst(35, 6000);
      window.ChurchAudio?.churchBell(1);
    }, 1400);
  }

  // Làm dấu Thánh Giá và quỳ cầu nguyện
  function signOfCross() {
    if (!player) return;
    player.state = 'kneel';
    player.bowStart = performance.now();
    effects.push({
      type: 'cross_heart', x: player.x, y: player.y - 150,
      t0: performance.now(), dur: 2200
    });
    window.ChurchAudio?.amenChime();
  }

  // Thỉnh chuông giáo đường
  function ringBell() {
    window.ChurchAudio?.churchBell(3);
    effects.push({
      type: 'sprite', img: 'fx_church_bell', x: 240, y: 920,
      s: 0.8, t0: performance.now(), dur: 3500, swing: true, glow: true
    });
    effects.push({ type: 'halo', t0: performance.now(), dur: 3500 });
    // Thả bồ câu bay
    spawnDove(AISLE_X, H - 200);
    setTimeout(() => spawnDove(AISLE_X - 100, H - 220), 400);
    setTimeout(() => spawnDove(AISLE_X + 100, H - 220), 800);
  }

  function spawnDove(x, y) {
    doves.push({
      x, y, vx: rnd(-0.8, 0.8), vy: rnd(-2.6, -4.0),
      s: rnd(0.5, 0.75), t0: performance.now(), dur: 7000
    });
  }

  function petalBurst(n, ms) {
    for (let i = 0; i < n; i++) {
      petals.push({
        x: rnd(-40, W + 40), y: rnd(-200, -20),
        vx: rnd(-0.7, 0.7), vy: rnd(1.3, 2.7),
        r: rnd(0, 6.28), vr: rnd(-0.04, 0.04),
        s: rnd(0.12, 0.22), born: performance.now() + rnd(0, ms * 0.6)
      });
    }
  }

  function burst(x, y, color, n) {
    for (let i = 0; i < n; i++) {
      const a = rnd(0, 6.28), s = rnd(1.5, 5);
      effects.push({
        type: 'spark', x, y,
        vx: Math.cos(a) * s, vy: Math.sin(a) * s - 2,
        life: rnd(0.6, 1.3), age: 0, color
      });
    }
  }

  // Vòng lặp Render chính
  function loop(now) {
    requestAnimationFrame(loop);
    const dt = Math.min(0.06, (now - lastTime) / 1000);
    lastTime = now;

    update(dt, now);
    draw(now);
  }

  function update(dt, now) {
    // Cập nhật người chơi
    updatePerson(player, dt, now);

    // Cập nhật NPC
    npcs.forEach((npc) => {
      updatePerson(npc, dt, now);
      if (now > npc.nextBow) {
        npc.bowStart = now;
        npc.nextBow = now + rnd(15000, 35000);
      }
    });

    // Cánh hoa rơi
    for (let i = petals.length - 1; i >= 0; i--) {
      const f = petals[i];
      if (now < f.born) continue;
      f.x += f.vx + Math.sin((now + i * 300) / 600) * 0.6;
      f.y += f.vy;
      f.r += f.vr;
      if (f.y > H + 30) petals.splice(i, 1);
    }

    // Bồ câu bay
    for (let i = doves.length - 1; i >= 0; i--) {
      const d = doves[i];
      const age = now - d.t0;
      if (age > d.dur) { doves.splice(i, 1); continue; }
      d.x += d.vx + Math.sin(age / 500) * 0.8;
      d.y += d.vy;
      if (d.y < -150) doves.splice(i, 1);
    }

    // Hiệu ứng hạt
    for (let i = effects.length - 1; i >= 0; i--) {
      const e = effects[i];
      if (e.type === 'spark') {
        e.age += dt; e.x += e.vx; e.y += e.vy; e.vy += 0.12;
        if (e.age > e.life) effects.splice(i, 1);
      } else if (now - e.t0 > e.dur) {
        effects.splice(i, 1);
      }
    }
  }

  function updatePerson(p, dt, now) {
    if (!p) return;
    if (p.state === 'walk') {
      const tgt = p.path[0];
      if (!tgt) {
        p.state = p.after || 'sit';
        p.path = [];
        return;
      }
      const dx = tgt.x - p.x, dyDist = tgt.y - p.y;
      const d = Math.hypot(dx, dyDist);
      const sp = (130 + 300 * scaleAt(p.y)) * dt;
      p.flip = Math.abs(dx) > Math.abs(dyDist) && dx < 0;
      if (d <= sp) {
        p.x = tgt.x; p.y = tgt.y;
        p.path.shift();
        if (!p.path.length) p.state = p.after || 'sit';
      } else {
        p.x += (dx / d) * sp; p.y += (dyDist / d) * sp;
      }
      p.ft += dt;
      if (p.ft > 0.15) { p.ft = 0; p.frame = (p.frame + 1) % 4; }
    } else if (p.state === 'offer') {
      p.frame = 6;
      if (!p.t0) p.t0 = now;
      if (now - p.t0 > 5000) {
        p.state = 'walk';
        p.after = 'sit';
        p.path = [{ x: AISLE_X, y: p.y }, { x: 380, y: 1340 }];
        p.t0 = 0;
      }
    } else if (p.state === 'kneel') {
      p.frame = 6;
    } else {
      p.frame = 7;
    }
  }

  // Vẽ hình
  function draw(now) {
    const dy = getSceneDY();
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.fillStyle = '#090d16';
    ctx.fillRect(0, 0, W, H);

    ctx.save();
    ctx.translate(0, dy);

    // Vẽ ảnh nền (Cung thánh hoặc Tháp chuông)
    const bgImg = bgStyle === 'altar' ? IMG.church_altar : IMG.church_tower;
    if (ok(bgImg)) {
      ctx.drawImage(bgImg, 0, 0, W, H);
      ctx.drawImage(bgImg, 0, bgImg.naturalHeight - 6, bgImg.naturalWidth, 6, 0, H - 1, W, -dy + 2);
    }

    // Vẽ các hàng ghế gỗ
    drawChurchPews();

    // Hào quang Cung Thánh & Đèn nến
    drawSanctuaryGlow(now);

    // Vẽ các ngọn nến đang cháy trên bàn thờ
    drawAltarCandles(now);

    // Vẽ tất cả người có mặt (xếp theo trục Y để tạo chiều sâu)
    const peopleList = [player, ...npcs].filter(Boolean).sort((a, b) => a.y - b.y);
    peopleList.forEach((p) => drawPerson(p, now));

    drawEffects(now);
    drawDoves(now);

    ctx.restore();

    // Cánh hoa rơi ở lớp trên cùng
    drawPetals(now);
  }

  function drawChurchPews() {
    ctx.save();
    const pewColor = 'rgba(74, 38, 14, 0.55)';
    const pewHighlight = 'rgba(180, 110, 50, 0.65)';
    const rows = [1280, 1360, 1460, 1580];

    rows.forEach((y) => {
      const s = scaleAt(y);
      const w = 340 * s;
      const h = 28 * s;
      
      // Hàng ghế trái
      roundRect(320 - w / 2, y + 8, w, h, 6 * s);
      ctx.fillStyle = pewColor; ctx.fill();
      roundRect(320 - w / 2, y + 8, w, 4 * s, 2 * s);
      ctx.fillStyle = pewHighlight; ctx.fill();

      // Hàng ghế phải
      roundRect(760 - w / 2, y + 8, w, h, 6 * s);
      ctx.fillStyle = pewColor; ctx.fill();
      roundRect(760 - w / 2, y + 8, w, 4 * s, 2 * s);
      ctx.fillStyle = pewHighlight; ctx.fill();
    });
    ctx.restore();
  }

  function drawSanctuaryGlow(now) {
    ctx.save();
    ctx.globalCompositeOperation = 'lighter';
    const ay = getAltarY();
    ctx.globalAlpha = 0.16 + 0.05 * Math.sin(now / 1400);
    sprite(IMG.fx_halo, 540, ay - 240, 1.8);
    ctx.restore();
  }

  function drawAltarCandles(now) {
    altarCandles.forEach((c) => {
      const fl = Math.sin((now + c.x * 20) / 120) * 2;
      sprite(IMG.fx_candle, c.x, c.y, 0.45);
      // Ngọn lửa lung linh
      ctx.save();
      ctx.globalCompositeOperation = 'lighter';
      const gr = ctx.createRadialGradient(c.x, c.y - 75 + fl, 2, c.x, c.y - 75 + fl, 28);
      gr.addColorStop(0, 'rgba(255, 230, 120, 0.7)');
      gr.addColorStop(1, 'rgba(255, 140, 30, 0)');
      ctx.fillStyle = gr;
      ctx.fillRect(c.x - 30, c.y - 105, 60, 60);
      ctx.restore();
    });
  }

  function drawPerson(p, now) {
    const anim = hasAnim(p.skin);
    const seated = p.state === 'sit' || (p.state === 'kneel' && p.after === 'sit');
    const ws = seated ? (scaleAt(p.y) * 0.95) : scaleAt(p.y);

    let bowK = 0;
    if (p.bowStart && now - p.bowStart < 2400) {
      bowK = Math.sin(((now - p.bowStart) / 2400) * Math.PI) * 0.12;
    }

    ctx.save();
    ctx.translate(p.x, p.y);
    if (bowK) ctx.transform(1, 0, 0, 1 - bowK, 0, 0);

    let topY = 260 * ws * 1.05;

    if (anim) {
      const a = ANIM[p.skin];
      const k = (ws * 1.05 * 260) / a.seatH;
      if (p.flip) ctx.scale(-1, 1);
      ctx.drawImage(IMG['anim_' + p.skin], p.frame * a.fw, 0, a.fw, a.fh, (-a.fw * k) / 2, -a.fh * k, a.fw * k, a.fh * k);
      topY = (p.frame === 7 ? a.seatH : a.fh * 0.95) * k;
    } else {
      if (facesLeft(p.x)) ctx.scale(-1, 1);
      const spriteImg = IMG['c_' + p.skin] || IMG.c_man;
      sprite(spriteImg, 0, 0, ws * 1.05);
    }
    ctx.restore();

    // Bảng tên nhân vật
    drawTag(p, p.x, p.y - topY - 14, ws);
  }

  function drawTag(p, x, y, ws) {
    const f = Math.max(0.65, Math.min(1.15, ws / 0.62));
    const fs = Math.round(16 * f);
    ctx.save();
    ctx.font = `700 ${fs}px -apple-system, sans-serif`;
    const tw = ctx.measureText(p.name).width;
    const w = tw + 28;
    const h = fs + 14;

    ctx.fillStyle = p.isPlayer ? 'rgba(180, 83, 9, 0.92)' : 'rgba(15, 23, 42, 0.85)';
    roundRect(x - w / 2, y - h, w, h, h / 2);
    ctx.fill();
    if (p.isPlayer) {
      ctx.strokeStyle = '#facc15';
      ctx.lineWidth = 2;
      ctx.stroke();
    }

    ctx.fillStyle = p.isPlayer ? '#fef08a' : '#f8fafc';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(p.name, x, y - h / 2 + 1);
    ctx.restore();
  }

  function drawEffects(now) {
    effects.forEach((e) => {
      if (e.type === 'sprite') {
        const k = (now - e.t0) / e.dur;
        const a = k < 0.15 ? k / 0.15 : k > 0.75 ? (1 - k) / 0.25 : 1;
        ctx.save();
        ctx.globalAlpha = Math.max(0, a);
        ctx.translate(e.x, e.y - (e.rise || 0) * k);
        if (e.swing) ctx.rotate(Math.sin(k * 18) * 0.25 * (1 - k));
        sprite(IMG[e.img], 0, 0, e.s);
        ctx.restore();
      } else if (e.type === 'cross_heart') {
        const k = (now - e.t0) / e.dur;
        ctx.globalAlpha = Math.max(0, 1 - k);
        ctx.font = '32px sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('✝️', e.x, e.y - k * 100);
        ctx.globalAlpha = 1;
      }
    });
  }

  function drawDoves(now) {
    const im = IMG.fx_dove;
    doves.forEach((d) => {
      const k = (now - d.t0) / d.dur;
      ctx.save();
      ctx.globalAlpha = Math.max(0, k < 0.1 ? k / 0.1 : k > 0.85 ? (1 - k) / 0.15 : 1);
      ctx.translate(d.x, d.y);
      if (ok(im)) sprite(im, 0, 0, d.s);
      ctx.restore();
    });
  }

  function drawPetals(now) {
    const im = IMG.fx_petal;
    petals.forEach((f) => {
      if (now < f.born) return;
      ctx.save();
      ctx.translate(f.x, f.y);
      ctx.rotate(f.r);
      if (ok(im)) ctx.drawImage(im, -im.naturalWidth * f.s / 2, -im.naturalHeight * f.s / 2, im.naturalWidth * f.s, im.naturalHeight * f.s);
      ctx.restore();
    });
  }

  function sprite(im, x, y, s, ay = 1) {
    if (!ok(im)) return;
    const w = im.naturalWidth * s, h = im.naturalHeight * s;
    ctx.drawImage(im, x - w / 2, y - h * ay, w, h);
  }

  function roundRect(x, y, w, h, r) {
    ctx.beginPath(); ctx.moveTo(x + r, y);
    ctx.arcTo(x + w, y, x + w, y + h, r); ctx.arcTo(x + w, y + h, x, y + h, r);
    ctx.arcTo(x, y + h, x, y, r); ctx.arcTo(x, y, x + w, y, r);
    ctx.closePath();
  }

  // Public API
  window.ChurchGame = {
    init,
    lightCandle,
    offerRose,
    signOfCross,
    ringBell,
    setPlayerName(n) {
      if (!n || !player) return;
      player.name = n;
      localStorage.setItem('nto_name', n);
    },
    setPlayerSkin(s) {
      if (!s || !player) return;
      player.skin = s;
      localStorage.setItem('nto_skin', s);
    },
    setBgStyle(s) {
      bgStyle = s === 'tower' ? 'tower' : 'altar';
      localStorage.setItem('nto_bg', bgStyle);
    },
    getBgStyle: () => bgStyle,
    getPlayer: () => player
  };
})();
