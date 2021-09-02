clear all; close all; clc;

g = imread('fish.png'); % fishIT.jpeg
g = rgb2gray(g);

figure(1); subplot(3,4,1); imshow(g); title('g (border points)'); % вывод на экран точек границы двумерной последовательности
g=double(g); % превращение всех значений в тип double

[x, y] = size(g); % берутся размеры рисунка
if x < y % период обрабатываемого дискретного сигнала
  N = y;
else
  N = x;
end

% Матрица дискретного множества ортогональных функций ДПХ
H = zeros(N, N);
for v = 0: N -1 % частотный параметр - определяет номер строки матрицы ядра ДПХ
    for n = 0: N -1 % временной параметр - определяет номер столбца матрицы H h ‒ ядра ДПХ
        H(v + 1, n + 1) = cos((2 * pi * v * n) / N) + sin((2 * pi * v * n) / N); 
        % матрица зависящая только от размера рисунка а не от него самого
    end
end
figure(1); subplot(3,4,2); imshow(H); title('Discrete set of orthogonal functions DHT'); 

% Закодированный образ g_caret (Hartley Descriptors)
g_caret = g * H; % Хартли образ последовательности отсчетов gn
figure(1); subplot(3,4,3); imshow(g_caret); title('Hartley image sequence'); 

% Полное восстановление изображения
G_fully_restored = 1/N * g_caret * H; % ошибка = 0
figure(1); subplot(3,4,4); imshow(G_fully_restored); title('mse=0');

count_pic=5; 
max_element = max(max(abs(g_caret)));
mas_i = [0.01, 0.04, 0.08, 0.12, 0.16, 0.2, 0.24, 0.28]; 
Sigmas = zeros(8, 1); % среднеквадратичные ошибки (СКО)
Hartley_descriptors_left = zeros(8,1);
for i = 1: 8
    border = mas_i(i) * max_element; % массив долей от максимального элемента
    cutting_mask = abs(g_caret) > border; % какие элементы обнуляем а какие оставляем как есть
    Hartley_descriptors_left(i) = sum(sum(cutting_mask));
    cutted_coded_img = g_caret .* cutting_mask; % создание обрезанного образа
    cutted_img_restored = (1/N * cutted_coded_img * H);
    sigma = 0;
    for n = 1:N
      for v = 1:N
         sigma = sigma + (g(n, v) - cutted_img_restored(n, v))^2;
      end
    end
    sigma = sqrt(sigma /(2*N)); % Mean squared error
    Sigmas(i)= sigma;
    figure(1), subplot(3,4,count_pic), imshow(cutted_img_restored,[]); count_pic=count_pic+1;
    drawnow; title({'mse=' num2str(Sigmas(i)), num2str(Hartley_descriptors_left(i)) '/256' });
end

figure(2), plot(Hartley_descriptors_left,Sigmas); title('Зависимость СКО от числа признаков Хартли');