// ============================================
// 基本寸法パラメータ (単位: mm)
// ============================================
left_w       = 10;   // 左側ブロックの幅
left_h       = 2;    // 左側ブロックの厚み (高さ)

pillar_w     = 2;    // 中央ピラーの幅
pillar_top_h = 11;   // 左側上面からピラー頂面までの高さ
total_h      = left_h + pillar_top_h; // 全高 (2 + 11 = 13mm)

right_w      = 9;    // 右側ブロックの幅
right_h      = 2;    // 右側ブロックの厚み (適宜調整)

extrude_len  = 100;  // 押し出し長さ: 10cm = 100mm

// ============================================
// 面取り・穴パラメータ (単位: mm)
// ============================================
chamfer_left  = 0.5; // 左下角の面取り幅 (C面)
chamfer_right = 1.0; // 右下(ピラー底面右)角の面取り幅 (C面)

screw_d       = 3.2; // 穴の直径 (通し穴マージン込み)
screw_pos_x   = 5;   // 右側ブロック左端(ピラー右面)からの距離 (幅方向)

// 2箇所の穴の位置 (押し出しZ軸方向: 端からのオフセット)
screw_pos_z1  = 25;  // 1つ目の穴のZ座標
screw_pos_z2  = 75;  // 2つ目の穴のZ座標

$fn = 60; // 円筒の滑らかさ

// ============================================
// 3Dモデル生成
// ============================================
difference() {
    // 押し出し本体 (底面側の角を面取りしたポリゴン)
    linear_extrude(height = extrude_len) {
        polygon(points = [
            // 左下角の面取り
            [chamfer_left, 0],
            
            // ピラー右下角の面取り
            [left_w + pillar_w - chamfer_right, 0],
            [left_w + pillar_w, chamfer_right],
            
            // 右側ブロックおよび上部形状
            [left_w + pillar_w, total_h - right_h],
            [left_w + pillar_w + right_w, total_h - right_h],
            [left_w + pillar_w + right_w, total_h],
            [left_w, total_h],
            [left_w, left_h],
            [0, left_h],
            
            // 左下角の面取りの戻り
            [0, chamfer_left]
        ]);
    }

    // 木ネジ用貫通穴 (2箇所)
    for (z = [screw_pos_z1, screw_pos_z2]) {
        translate([
            left_w + pillar_w + screw_pos_x,
            total_h - right_h - 1,
            z
        ])
        rotate([-90, 0, 0])
        cylinder(d = screw_d, h = right_h + 2);
    }
}

