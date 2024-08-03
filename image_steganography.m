clc;
clear all;
close all;
% Read the cover image
coverImage = imread("C:\Users\ADMIN\OneDrive\Desktop\DIP\cat.jpg");

% Convert the secret message to binary
secretMessage = 'Hello' ;
binaryMessage = dec2bin(double(secretMessage), 8); % Convert each character to 8-bit binary

% Get the size of the message
[numRows, numCols] = size(binaryMessage);

% Check if the cover image can accommodate the secret message
maxMessageLength = numel(coverImage) * 3; % Each pixel has three color channels (RGB)
if numRows * numCols > maxMessageLength
    error('Cover image is too small to hold the secret message');
end

% Reshape the cover image to a vector
coverImageVector = reshape(coverImage, 1, []);

% Pad the binary message vector with zeros to match the size of the cover image vector
binaryMessageVector = reshape(binaryMessage', 1, []); % Transpose binary message for proper reshaping
binaryMessageVector = [binaryMessageVector, zeros(1, numel(coverImageVector) - numel(binaryMessageVector))];

% Convert the vectors to uint8 data type
coverImageVector = uint8(coverImageVector);
binaryMessageVector = uint8(binaryMessageVector);

% Modify the least significant bit of each pixel
modifiedImageVector = bitset(coverImageVector, 1, binaryMessageVector);

% Reshape the modified image vector back to the original size
modifiedImage = reshape(modifiedImageVector, size(coverImage));

% Save the modified image
imwrite(modifiedImage, "C:\Users\ADMIN\OneDrive\Desktop\DIP\stego_img.jpg");

disp('Message encoded successfully.');
% Read the stego image
stegoImage = imread("C:\Users\ADMIN\OneDrive\Desktop\DIP\stego_img.jpg");

% Reshape the stego image to a vector
stegoImageVector = reshape(stegoImage, 1, []);

% Extract the least significant bit from each pixel
extractedMessageVector = bitget(stegoImageVector, 1);

% Reshape the extracted message vector to the original size
numPixels = numel(stegoImage);
numMessageBits = floor(numPixels / 8) * 8; % Number of bits to consider based on image size
extractedMessageVector = extractedMessageVector(1:numMessageBits); % Consider only the required bits

% Reshape the extracted message vector into a matrix of 8-bit segments
numSegments = numMessageBits / 8;
extractedMessageMatrix = reshape(extractedMessageVector, 8, numSegments)';

% Convert the binary segments to characters
extractedMessage = char(bin2dec(num2str(extractedMessageMatrix)))';

disp('Decoded message:');
disp(extractedMessage);
