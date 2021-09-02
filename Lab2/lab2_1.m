clear all; close all; clc;

% Кодовый алфавит
alphabet = [0 1];
%alphabet = [1 -1];

% Основание кода q кодового алфавита – число различных элементов алфавита, выбранное для построения кода.
q = length(alphabet); 

% Значность кода. Длина n кода (значность) – число символов кодового слова.
% n = 6; 
n = 15;

% Размерность k кода – число информационных элементов(позиций) кодового слова.
k = 3; 
% k = 4;

% Расстояние кода d.
d = 3; 
% d = 8;

% Mаксимальное число кодовых слов при заданных q и n.
Mmax = q^n;

% Мощность кода – это число различных кодовых последовательностей (комбинаций), разрешенных для кодирования.
M = q^k;

% 1. Создаём массив всех возможных кодовых слов (codesN) ДВОИЧНЫЙ ВИД
codesN = zeros( Mmax, n);
for i = 1: Mmax
     codeN = dec2bin(i-1);
     for j = (length(codeN)-1): -1: 0
         codesN(i,n-j) = str2num(codeN(length(codeN)-j));
     end
end

% 2. Меняем codesN в соответствии с алфавитом
for i = 1: Mmax
    for j = 1: n
        codesN(i,j) = alphabet(codesN(i,j)+1);
    end
end
% disp(codesN);

% 3. Создаём массив кодовых последовательностей(комбинаций) (codesK)
codesK = zeros( M, k);
for i = 1: M
     codeK = dec2bin(i-1);
     for j = (length(codeK)-1): -1: 0
         codesK(i,k-j) = str2num(codeK(length(codeK)-j));
     end
end

% 4. Меняем codesK в соответствии с алфавитом
for i = 1: M
    for j = 1: k
        codesK(i,j) = alphabet(codesK(i,j)+1);
    end
end
% disp(codesK);

% 5. Ищем из массива всех возможных кодовых слов (codesN)
codesX = zeros(M, n);
for column = 1:n
    codesX(1,column) = codesN(1,column);
end
Ncount = 1;

% 6. Создаём массив разрешённых последовательностей(codesX). 
% Ищем из массива всех возможных кодовых слов (codesN) - слова с расстоянием d
flag = false;
for rowN = 2: Mmax
    for rowX = 1: Ncount
        differences = 0;
        for column = 1: n
           if codesX(rowX, column) ~= codesN(rowN, column)
              differences = differences + 1;
           end
        end
        if differences < d
            flag = true;
            break;
        end
        flag = false;
    end
    if flag 
        continue;
    end     
    for column = 1:n
        %disp( codesN 
        codesX(Ncount+1,column) = codesN(rowN,column);
    end
    Ncount = Ncount + 1;
end

% 7. Выводим соответствие кодовая последовательность(комбинация)(codesK[i])(оригинал слова) -> кодовое слово из codesN[i]
for i = 1 : M 
        fprintf('%d) %s -> %s\n', i-1, mat2str(codesK(i,:)), mat2str(codesX(i,:)));
end

% 8. Выделяем случайную последовательность размером кратную k
%z = [ 1 1 1 0 1 0 1 0 ]
z = [ 1 1 1 0 1 0 0 1 1 1 1 0 0 1 0];
fprintf('\nz = %s\n\n', mat2str(z(1,:)));

% 9. Кодируем последовательность z в z_coded
% - находим соответстивие часть последовательности размером k и кодового слова из codesN[i]
words_count = length(z)/k;
z_coded_words = zeros( words_count , n);

% разбиваем последов%pdist(str2double(z_coded_words(1,:)), str2double(codesX(1,:)))ательность z на слова кратные k в матрицу z_words
z_words = zeros( words_count , k);
for i = 1 : words_count
    for j = 1 : k
        t = (i-1)*k+j;
        z_words(i,j) = z(t);
    end
end

% находим коды соответствующие словам последовательности и формируем закодированные слова
for i = 1 : words_count
   word = z_words(i,:); 
   for j = 1 : M 
       if codesK(j,:) == word
           z_coded_words(i,:) = codesX(j,:);
       end
   end
end

for i = 1: words_count 
    fprintf('%s -> %s\n', mat2str(z_words(i,:)), mat2str(z_coded_words(i,:)));
end
    
% 10. Создаём переданную последовательность (по 1 ошибке в каждом слове закодированной последовательности(z_coded_words))
for i = 1: words_count
    for errors = n : - 1 : n %- 1
        if z_coded_words(i,errors) == 0
            z_coded_words(i,errors) = 1; 
        else
            z_coded_words(i,errors) = 0;
        end
    end
end

disp('Let''s transfer with an error in each word:')
for i = 1: words_count 
    fprintf('%s -> %s\n', mat2str(z_words(i,:)), mat2str(z_coded_words(i,:)));
end

% 11. Расчитываем разницу между двумя векторами (степень удаленности любых кодовых последовательностей друг от друга) для каждого слова
%pdist(str2double(z_coded_words(1,:)), str2double(codesX(1,:)))

z_decoded_words = zeros( words_count , k);

% находим коды соответствующие словам последовательности и формируем закодированные слова
for word_num = 1 : words_count
   word = z_coded_words(word_num,:); 
   min_difference = n; 
   min_x_num = 0;
   for i = 1 : M 
       differences = 0;
       for j = 1 : n
           if codesX(i, j) ~= word(j)
              differences = differences + 1;
           end
       end
       
       if differences < min_difference
           min_difference = differences;
           min_x_num = i;
       end
   end
   z_decoded_words(word_num,:) = codesK(min_x_num,:);
end

disp('The decoded code after the transfer is:')
for i = 1: words_count 
    fprintf('%s -> %s\n', mat2str(z_words(i,:)), mat2str(z_decoded_words(i,:)));
end
