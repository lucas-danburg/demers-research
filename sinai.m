function table=sinai(w,r,to)
global t
global table
table=[rectang(w,w,to);circle(r,to+4*w)];
table{5,2}=inline(['-',char(table{5,2})],'t');   %reverse direction circle is traced in
