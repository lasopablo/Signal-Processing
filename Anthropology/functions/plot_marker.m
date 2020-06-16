function plot_marker(marker)

mark=8;

x_marker=marker(:,1);
y_marker=marker(:,2);
z_marker=marker(:,3);

plot3(x_marker, z_marker, y_marker,'ob','MarkerSize',mark,'MarkerFaceColor','b');
