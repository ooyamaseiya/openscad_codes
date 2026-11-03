// ==========================================
// キャスター用車輪止め (Caster Wheel Stop) - 尻尾・先端面取り版
// ==========================================

$fn = 100; // 円の滑らかさ

// --- パラメータ設定 ---
wheel_dia      = 59.92; // ノギスで測定された車輪の直径 (mm)
wheel_width    = 32.0;  // 車輪の幅 (mm)
clearance      = 1.5;   // 車輪がスムーズに収まるためのクリアランス (mm)

wall_thick     = 6.0;   // 側面の壁の厚み (mm)
bottom_thick   = 5.0;   // 底面の厚み (mm)

block_length   = 85.0;  // 車輪止めの全長 (mm)
block_height   = 30.0;  // 車輪止めの全高 (mm)

body_fillet_r  = 3.0;   // 全体外周の面取り半径 (mm)

// --- 尻尾（スロープ先端）の面取り設定 ---
tail_blunt_h   = 1.8;   // 尻尾先端の立ち上がり厚み (mm) ※1.5〜2.5mm推奨
tail_fillet_r  = 1.2;   // 尻尾先端エッジの丸め半径 (mm) ※0でフラットカットのみ

// --- 角丸ブロック生成モジュール ---
module rounded_block(size, r) {
    w = size[0];
    l = size[1];
    h = size[2];

    if (r <= 0) {
        translate([-w / 2, -l / 2, 0])
            cube([w, l, h]);
    } else {
        hull() {
            for (x = [-w / 2 + r, w / 2 - r]) {
                for (y = [-l / 2 + r, l / 2 - r]) {
                    translate([x, y, 0])
                        cylinder(r = r, h = h - r);
                    translate([x, y, h - r])
                        sphere(r = r);
                }
            }
        }
    }
}

// --- モデリング本体 ---
module caster_stop() {
    total_width    = wheel_width + (wall_thick * 2);
    wheel_r        = (wheel_dia + clearance) / 2;
    wheel_center_z = bottom_thick + wheel_r;
    slope_angle    = 35;

    // スロープが地面(Z=0)と交差する計算上のY座標
    slope_y_ground = 21.62;
    // 厚みを持たせるためのカット位置
    tail_cut_y     = slope_y_ground - (tail_blunt_h / tan(slope_angle));

    difference() {
        // 1. 面取りされたベースブロック
        rounded_block([total_width, block_length, block_height], body_fillet_r);

        // 2. 車輪を収めるための溝
        translate([0, 0, wheel_center_z])
            rotate([0, 90, 0])
                cylinder(h = total_width + 4, r = wheel_r, center = true);

        // 3. 手前のスロープ
        translate([0, block_length / 2 + 10, block_height / 2])
            rotate([-slope_angle, 0, 0])
                cube([total_width + 4, block_length, block_height * 2], center = true);

        // 4. 尻尾（スロープ先端）の厚み付けカット（極薄部分の切除）
        if (tail_blunt_h > 0) {
            translate([-(total_width + 6) / 2, tail_cut_y, -1])
                cube([total_width + 6, block_length, block_height]);
        }

        // 5. 尻尾先端エッジのR面取りカッター
        if (tail_blunt_h > 0 && tail_fillet_r > 0) {
            translate([0, tail_cut_y - tail_fillet_r, tail_blunt_h - tail_fillet_r])
                difference() {
                    translate([-(total_width + 6) / 2, 0, 0])
                        cube([total_width + 6, tail_fillet_r * 2, tail_fillet_r * 2]);
                    rotate([0, 90, 0])
                        cylinder(r = tail_fillet_r, h = total_width + 8, center = true);
                }
        }
    }
}

// 実行
caster_stop();

