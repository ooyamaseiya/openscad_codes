// ============================================
// 基本寸法パラメータ (単位: mm)
// ============================================
left_w       = 10;   // 左側ブロックの幅
left_h       = 2;    // 左側ブロックの厚み (高さ)

pillar_w     = 2;    // 中央ピラーの幅
pillar_top_h = 11;   // 左側上面からピラー頂面までの高さ
total_h      = left_h + pillar_top_h; // 全高 (2 + 11 = 13mm)

right_w      = 6;    // 右側ブロックの幅
right_h      = 7;    // 右側ブロックの厚み (適宜調整)

extrude_len  = 100;  // 押し出し長さ: 10cm = 100mm

// ============================================
// 面取りパラメータ (単位: mm)
// ============================================
chamfer_left         = 0.5; // 最下部・左下角の面取り
chamfer_pillar_right = 1.0; // 最下部・ピラー右下角の面取り
chamfer_bottom_right = 1.0; // 右側ブロックの右下角の面取り

// ============================================
// 直角三角形の床パラメータ (最下部 Z=0〜2mm)
// ============================================
floor_t     = 2;    // 床の厚み (Z方向: 2mm)
tri_left_s  = 5;    // 左側凹みの直角二等辺三角形のサイズ (最大 left_w)
tri_right_s = 5;    // 右側凹みの直角二等辺三角形のサイズ (最大 right_w)

// ============================================
// 木ネジ穴パラメータ (単位: mm)
// ============================================
screw_d       = 3.2; // 穴の直径
screw_pos_x   = 3;   // 右側ブロック内でのX位置
screw_pos_z1  = 25;  // 1つ目の穴のZ座標
screw_pos_z2  = 75;  // 2つ目の穴のZ座標

$fn = 60;

// ============================================
// 3Dモデル生成
// ============================================
difference() {
    union() {
        // 1. メインの柱（断面を10cm押し出した本体）
        linear_extrude(height = extrude_len) {
            polygon(points = [
                // 左下角
                [chamfer_left, 0],
                // ピラー右下角
                [left_w + pillar_w - chamfer_pillar_right, 0],
                [left_w + pillar_w, chamfer_pillar_right],
                // 右側ブロック下面
                [left_w + pillar_w, total_h - right_h],
                // 右側ブロック右下角
                [left_w + pillar_w + right_w - chamfer_bottom_right, total_h - right_h],
                [left_w + pillar_w + right_w, total_h - right_h + chamfer_bottom_right],
                // 右側ブロック右上角
                [left_w + pillar_w + right_w, total_h],
                // ピラー頂面
                [left_w, total_h],
                // 左側ブロック上面
                [left_w, left_h],
                [0, left_h],
                // 左下角戻り
                [0, chamfer_left]
            ]);
        }

        // 2. 最下部 (Z=0〜2mm) に追加する直角三角形の床 (2箇所)
        linear_extrude(height = floor_t) {
            // ① 左側の凹みコーナー（ピラー左面 × 左側ブロック上面）
            polygon(points = [
                [left_w, left_h],                      // コーナー直角部
                [left_w - tri_left_s, left_h],         // 左方向へ伸びる点
                [left_w, left_h + tri_left_s]          // 上方向へ伸びる点
            ]);

            // ② 右側の凹みコーナー（ピラー右面 × 右側ブロック下面）
            polygon(points = [
                [left_w + pillar_w, total_h - right_h],              // コーナー直角部
                [left_w + pillar_w + tri_right_s, total_h - right_h], // 右方向へ伸びる点
                [left_w + pillar_w, total_h - right_h - tri_right_s]  // 下方向へ伸びる点
            ]);
        }
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
