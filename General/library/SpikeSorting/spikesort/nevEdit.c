#include <math.h>
#include "mex.h"
#include <stdio.h>

unsigned int packetSize;
int bytesPerSample = 2;
int numSamples;

void moveUnits(FILE * fid, unsigned char source, unsigned char target)
{
 unsigned long timeStamp;
 short packetID;
 int count;
 unsigned char unit;

 count = 0;
 while (fread(&timeStamp, 4, 1, fid)>0)
 {
   fread(&packetID, 2, 1, fid);
   fread(&unit,1,1,fid);

   if (unit == source)
   {
     fseek(fid,-1,SEEK_CUR);

     fwrite(&target,1,1,fid);
     count++;
   }

   fseek(fid,packetSize-7,SEEK_CUR);
 }

 mexPrintf("All waveforms (%i) from code %i moved to code %i\n",count,source, target);
 mexEvalString("drawnow;");
}

void markElectricalNoise(FILE * fid, int electrodeThreshold, unsigned char target)
{
 unsigned long timeStamp;
 unsigned long lastTimeStamp;
 short packetID;
 int count, tsCount;
 unsigned char unit;
 unsigned char unit2;
 short * waveform;
 int isNoise;
 int i;
 
 waveform = (short *)mxCalloc(numSamples,sizeof(short));

 lastTimeStamp = -1;
 count = 1;
 tsCount = 0;
 while (fread(&timeStamp, 4, 1, fid)>0)
 {
   fread(&packetID, 2, 1, fid);
   fread(&unit,1,1,fid);

   fseek(fid,1,SEEK_CUR);

   fread(waveform,bytesPerSample,numSamples,fid);

   if (timeStamp == lastTimeStamp)
     count++;
   else
   {
     if (count > electrodeThreshold)
     {
       fseek(fid,-(int)packetSize*(count+1),SEEK_CUR);

       for (i = 0; i < count; i++)
       {
         fread(&timeStamp, 4, 1, fid);
         fread(&packetID, 2, 1, fid);
         /* must do fseek before switching to writing */
         fseek(fid,0,SEEK_CUR);
         fwrite(&target,1,1,fid);
         fseek(fid,packetSize-7,SEEK_CUR);
       }

       tsCount++;

       fread(&timeStamp, 4, 1, fid);
       fread(&packetID, 2, 1, fid);
       fread(&unit,1,1,fid);
       fseek(fid,packetSize-7,SEEK_CUR);
     }
     count = 1;
   }

   lastTimeStamp = timeStamp;
 }

 mexPrintf("%i timestamps were written as sort code %i\n",tsCount,target);
 mexEvalString("drawnow;");

 mxFree(waveform);
}

void thresholdSpikes(FILE * fid, int threshold, unsigned char target, int lowThresh)
{
 unsigned long timeStamp;
 short packetID;
 int count;
 unsigned char unit;
 unsigned char unit2;
 short * waveform;
 int exceeds;
 int i;

 waveform = (short *)mxCalloc(numSamples,sizeof(short));

 count = 0;
 while (fread(&timeStamp, 4, 1, fid)>0)
 {
   fread(&packetID, 2, 1, fid);
   fread(&unit,1,1,fid);

   fseek(fid,1,SEEK_CUR);

   fread(waveform,bytesPerSample,numSamples,fid);
   exceeds = 0;

   for (i = 0; i < numSamples; i++)
   {
     if (waveform[i] > threshold || waveform[i] < -threshold)
       exceeds = 1;
   }

   if (!lowThresh)
     exceeds = 1 - exceeds;

   if (exceeds)
   {
     if (packetID < 129)
     {
       fseek(fid,-(int)packetSize+6,SEEK_CUR);
       fwrite(&target,1,1,fid);
       fseek(fid,packetSize-7,SEEK_CUR);
       count++;
     }
   }
 }

 mexPrintf("%i waveforms written as sort code %i\n",count,target);
 mexEvalString("drawnow;");

 mxFree(waveform);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 char * filename;
 FILE * fid;
 int buflen;
 char * method;

 char fileType[8];
 unsigned char version[2];
 char fileFormatAdditional[2];
 unsigned long headerSize;
 unsigned int timeResTimeStamps;
 unsigned int timeResSamples;
 unsigned short timeOrigin[8];
 char application[32];
 char comment[256];
 long extendedHeaderNumber;

 /* Get filename */
 buflen = mxGetM(prhs[0]) * mxGetN(prhs[0])+1;
 filename = mxCalloc(buflen, sizeof(char));
 mxGetString(prhs[0], filename, buflen);
 fid = fopen(filename,"rb+");

 /* Read the header */
 fread(fileType, 1, 8, fid);
 fread(version, 1, 2, fid);
 fread(fileFormatAdditional, 1, 2, fid);
 fread(&headerSize, 4, 1, fid);
 fread(&packetSize, 4, 1, fid);
 fread(&timeResTimeStamps, 4, 1, fid);
 fread(&timeResSamples, 4, 1, fid);
 fread(&timeOrigin, 2, 8, fid);
 fread(application, 1, 32, fid);
 fread(comment, 1, 256, fid);
 fread(&extendedHeaderNumber,4,1,fid);

 numSamples = (packetSize-8)/bytesPerSample;

 /* Get the task type */
 method = (char *) mxGetPr(prhs[1]);

 fseek(fid,headerSize,SEEK_SET);

 switch(*method)
 {
 case 'm':
   /* Move waveforms from one sort code to another sort code */
   moveUnits(fid,*mxGetPr(prhs[2]),*mxGetPr(prhs[3]));
   break;
 case 't':
   /* Threshold spikes at some +- value and move to a sort code */
   thresholdSpikes(fid,*mxGetPr(prhs[2]),*mxGetPr(prhs[3]),1);
   break;
 case 'n':
   /* Mark electrical noise by synchrony across channels, move to a sort code */
   markElectricalNoise(fid,*mxGetPr(prhs[2]),*mxGetPr(prhs[3]));
   break;
 case 'h':
   /* Move all spikes which DON'T exceed a thresholde +- value */
   thresholdSpikes(fid,*mxGetPr(prhs[2]),*mxGetPr(prhs[3]),0);
   break;   
 }

 fclose(fid);
}
