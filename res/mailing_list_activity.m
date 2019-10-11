function mailing_list_activity ()

data_file = "mailing_list_activity.mat";
if (exist (data_file, "file") == 2)
  load (data_file, "list_activity");
else
  list_activity = get_from_web ();
  save (data_file, "list_activity");
endif

plot_list_activity (list_activity(1,:));

endfunction

function list_activity = get_from_web ()
base_url  = "https://lists.gnu.org/archive/html";
this_year = str2num (datestr (date (), "yyyy"));
list_activity = cell(0, 2);
for list = {"help-octave", "octave-maintainers", "octave-bug-tracker"}
  activity = cell(0, 2);
  list_url = sprintf ("%s/%s/", base_url, list{1});
  for year = 1992:2019
    for month = 1:12
      tick = sprintf ("%d-%02d", year, month)
      try
        html = urlread ([list_url, tick]);
      catch
        continue; # on error
      end_try_catch
      val  = length (strfind (html, "<li><a"));
      activity(end + 1, :) = {tick, val};
    endfor
  endfor
  list_activity(end + 1, :) = {list, activity};
endfor
endfunction

function plot_list_activity (list_activity)
N = size (list_activity, 1);
for i = 1:N
  activity = list_activity{i, 2};
  data = cell2mat (activity (1:end-1, 2)); # don't count current month
  subplot (1, N ,i);
  bar (data);
  shading flat;
  hold on;
  plot (movmean (data, 6), "r", "linewidth", 4); # mean over six months
  hold off;
  title (sprintf ("%s (total: %d)", list_activity{i, 1}{1}, sum(data)));
  legend ("number of mails", "six month mean")
endfor
endfunction