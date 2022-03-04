#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
int main() {
	int width, depth;
	printf("Input Width:");
	scanf("%d", &width);
	printf("Input Depth:");
	scanf("%d", &depth);
	FILE* pdata = fopen("combination.txt", "r");
	FILE* pmif = fopen("software.mif", "w");
	if (pdata == NULL) {//防止打开失败
		cout << "文件读取失败！";
		exit(-1);
	}
	fprintf(pmif, "%s\n\n", "--Copyright(C) 2020 K.W. From NJUCS");
	fprintf(pmif, "%s%d%c\n", "Width = ", width, ';');
	fprintf(pmif, "%s%d%c\n\n", "Depth = ", depth, ';');
	fprintf(pmif, "%s\n", "ADDRESS_RADIX = UNS;");
	fprintf(pmif, "%s\n", "DATA_RADIX = HEX;");
	fprintf(pmif, "%s\n", "CONTENT BEGIN");
	int i = 0;
	char* temp = new char[28];
	while (!feof(pdata)) {
		fscanf(pdata, "%s", temp);
		fprintf(pmif, "\t%d%s%c%c%c\n", i++, "  :  ", temp[6], temp[7], ';');
		fprintf(pmif, "\t%d%s%c%c%c\n", i++, "  :  ", temp[4], temp[5], ';');
		fprintf(pmif, "\t%d%s%c%c%c\n", i++, "  :  ", temp[2], temp[3], ';');
		fprintf(pmif, "\t%d%s%c%c%c\n", i++, "  :  ", temp[0], temp[1], ';');
	}
	while (i < depth) {
		fprintf(pmif, "\t%d%s%c\n", i, "  :  00", ';');
		++i;
	}
	fprintf(pmif, "%s\n", "END");
	::fclose(pdata);
	::fclose(pmif);
	printf("生成成功：software.mif");
}