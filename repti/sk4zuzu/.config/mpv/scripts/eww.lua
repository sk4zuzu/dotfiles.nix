local utils = require "mp.utils"

function eww()
   local work_dir = mp.get_property_native("working-directory")
   local file_path = mp.get_property_native("path")
   local s = file_path:find(work_dir, 0, true)
   local final_path
   if s and s == 0 then
      final_path = file_path
   else
      final_path = utils.join_path(work_dir, file_path)
   end
   os.rename(final_path, final_path .. ".eww")
end

mp.add_key_binding("alt+del", "eww", eww)
