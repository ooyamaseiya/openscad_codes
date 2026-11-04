// ==========================================
// トイレ巾木 飛び散り防止カバー (L字型プロトタイプ)
// 固定構造不要（床・壁に沿わせるタイプ）
// ==========================================

// --- パラメータ設定 (単位: mm) ---
guard_height   = 85;    // 立ち上がり高さ（巾木をカバーする高さ）
floor_lip      = 15;    // 床側の張り出し幅（床面の飛び散りをガード）
part_length    = 150;   // 1パーツあたりの長さ（プリンターに合わせて調整可能）
wall_thickness = 2.0;   // カバーの肉厚

module l_shape_guard() {
    linear_extrude(height = part_length) {
        polygon(points=[
            [0, 0],                           // 1. 床と壁の交点（原点）
            [floor_lip, 0],                   // 2. 床側先端（外側）
            [floor_lip, wall_thickness],      // 3. 床側上面（内側）
            [wall_thickness, wall_thickness], // 4. 内側の角（コーナー）
            [wall_thickness, guard_height],   // 5. 壁側内面（右端）
            [0, guard_height]                 // 6. 壁側トップ（外側）
            // （自動的に [0, 0] へ戻り、壁面 [X=0] を下る閉じられたパスになります）
        ]);
    }
}

// レンダリング実行
l_shape_guard();
