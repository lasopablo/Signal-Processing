function plot_com(com)

mark=12; 

x_com=com(:,1);
y_com=com(:,2);
z_com=com(:,3);

plot3(x_com,z_com,y_com,'ok','MarkerSize',mark,'MarkerFaceColor','m') 

