function wagad_plot_regression(x,y)

mdl = fitlm(x,y);
Xnew = linspace(min(x), max(x), 1000)';
[ypred,yci] = predict(mdl, Xnew);
figure
plot(x, y, 'p')
hold on
plot(Xnew, ypred, '--g')
plot(Xnew, yci, '--r')
hold off
grid

end