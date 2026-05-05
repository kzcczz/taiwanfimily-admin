-- ============================================================
-- 場地規劃工具的 RLS Policy
-- ============================================================
-- 邏輯:任何「已登入 Supabase Auth」的使用者都能完整操作場地表
-- 沒登入的人 = 完全擋掉
-- 因為只有你和團隊在 Authentication > Users 裡的人能登入,
-- 等於「能進後台的人才能編輯」這個需求

-- ============================================================
-- venue_maps (場地表)
-- ============================================================

-- 清掉可能存在的舊 policy
DROP POLICY IF EXISTS "authenticated_can_read_venue_maps" ON venue_maps;
DROP POLICY IF EXISTS "authenticated_can_insert_venue_maps" ON venue_maps;
DROP POLICY IF EXISTS "authenticated_can_update_venue_maps" ON venue_maps;
DROP POLICY IF EXISTS "authenticated_can_delete_venue_maps" ON venue_maps;

-- 已登入者:可讀
CREATE POLICY "authenticated_can_read_venue_maps"
  ON venue_maps FOR SELECT
  TO authenticated
  USING (true);

-- 已登入者:可新增
CREATE POLICY "authenticated_can_insert_venue_maps"
  ON venue_maps FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- 已登入者:可修改
CREATE POLICY "authenticated_can_update_venue_maps"
  ON venue_maps FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- 已登入者:可刪除
CREATE POLICY "authenticated_can_delete_venue_maps"
  ON venue_maps FOR DELETE
  TO authenticated
  USING (true);


-- ============================================================
-- venue_layers (圖層表)
-- ============================================================

DROP POLICY IF EXISTS "authenticated_can_read_venue_layers" ON venue_layers;
DROP POLICY IF EXISTS "authenticated_can_insert_venue_layers" ON venue_layers;
DROP POLICY IF EXISTS "authenticated_can_update_venue_layers" ON venue_layers;
DROP POLICY IF EXISTS "authenticated_can_delete_venue_layers" ON venue_layers;

CREATE POLICY "authenticated_can_read_venue_layers"
  ON venue_layers FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "authenticated_can_insert_venue_layers"
  ON venue_layers FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "authenticated_can_update_venue_layers"
  ON venue_layers FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "authenticated_can_delete_venue_layers"
  ON venue_layers FOR DELETE
  TO authenticated
  USING (true);


-- ============================================================
-- venue-images Storage bucket 的 RLS Policy
-- ============================================================
-- 場地底圖上傳:必須登入才能上傳
-- 公開讀取:bucket 設成 public 就 OK,任何人能看到圖片網址就能讀

DROP POLICY IF EXISTS "authenticated_can_upload_venue_images" ON storage.objects;
DROP POLICY IF EXISTS "authenticated_can_delete_venue_images" ON storage.objects;
DROP POLICY IF EXISTS "anyone_can_read_venue_images" ON storage.objects;

CREATE POLICY "authenticated_can_upload_venue_images"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'venue-images');

CREATE POLICY "authenticated_can_delete_venue_images"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'venue-images');

CREATE POLICY "anyone_can_read_venue_images"
  ON storage.objects FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'venue-images');


-- ============================================================
-- 驗證
-- ============================================================
-- 跑完應該看到 venue_maps + venue_layers 各自有 4 條 policy

SELECT
  schemaname,
  tablename,
  policyname,
  cmd
FROM pg_policies
WHERE tablename IN ('venue_maps', 'venue_layers')
ORDER BY tablename, cmd;
