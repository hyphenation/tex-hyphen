/****************************************************************************
 *                                                                          *
 *          turk_hyf.c -- a program to produce PatGen-like hyphenation      *
 *                        patterns for the Turkish Language.                *
 *                                                                          *
 *          Copyright 1987, by Pierre A. MacKay.                            *
 *          This program and the resulting pattern file may be used         *
 *          freely by non-profit institutions.  Commercial users intending  *
 *          sale of any product incorporating this file should communicate  *
 *          with the author at the Humanities and Arts Computing Center     *
 *                                 Mail-Stop DW-10                          *
 *                                 University of Washington                 *
 *                                 Seattle, Washington 98105                *
 *                                                                          *
 ****************************************************************************/
#include <strings.h>
#include <stdio.h>

/* Temporary & ugly modification of original file by Mojca Miklavec; to take only Modern Turkish into account */
/* needs post-processing */
static char *tk_vowel[]=
  {"a", "e", "i", "i:", "o", "o:", "u", "u:"};
static char *tk_cons[]=
  {"b", "c", "c:", "d", "f", 
  "g", "g=", "h", "j", "k",
  "l", "m", "n", "p", "r", "s", "s:",
  "t", "v", "y", "z"};

int i,j;

main()
{
  printf("%% A mechanically generated Turkish Hyphenation table for TeX,\n");
  printf("%% using the University of Washington diacritical coding\n");
  printf("%% developed by P. A. MacKay for the Ottoman Texts Project.\n");

/* prohibit hyphen before pseudo-letters 
   and allow it after */
  printf("\\patterns{\n");

/* prohibit hyphen before vowels, allow after */
  for (i=0; i<(sizeof tk_vowel / sizeof &tk_vowel[0]); i++ )
    if (strlen(tk_vowel[i])==1) printf("2%s1\n",tk_vowel[i]);

/* allow hyphen either side of simple consonants */
  for (i=0; i<(sizeof tk_cons / sizeof &tk_cons[0]); i++ )
    if (strlen(tk_cons[i])==1) printf("1%s1\n",tk_cons[i]);

/* prohibit hyphen before disguised two-letter fragments */
  for (i=0; i<(sizeof tk_cons / sizeof &tk_cons[0]); i++ ) 
    for (j=0; j<(sizeof tk_vowel / sizeof &tk_cons[0]); j++ ) 
      if ((strlen(tk_cons[i]) + strlen(tk_vowel[j]))>2)
	printf("2%s%s.\n",tk_cons[i], tk_vowel[j]);

/* prevent e-cek at end of word */
  printf("2e2cek.\n");

/* prohibit hyphen before pair of consonants---many
   pairs generated here are impossible anyway */
  for (i=0; i<(sizeof tk_cons / sizeof &tk_cons[0]); i++ ) 
    for (j=0; j<(sizeof tk_cons / sizeof &tk_cons[0]); j++ ) 
      printf("2%s%s\n",tk_cons[i], tk_cons[j]);

/* allow hyphen between vowels, but not after second vowel of
   pair---several phonetically impossible pairs here */
  for (i=0; i<(sizeof tk_vowel / sizeof &tk_cons[0]); i++ )
    for (j=0; j<(sizeof tk_vowel / sizeof &tk_cons[0]); j++ )
      printf("%s3%s2\n",tk_vowel[i], tk_vowel[j]);

/* prohibit hyphen after disguised single vowels
   at start of word */
  for (i=0; i<(sizeof tk_vowel / sizeof &tk_vowel[0]); i++ )
    if (strlen(tk_vowel[i])>1) printf(".%s2\n",tk_vowel[i]);

/* a couple of consonant-clusters */
  printf("tu4r4k\nm1t4rak\n");

/* terminate the patterns. */
  printf("}\n");
}
