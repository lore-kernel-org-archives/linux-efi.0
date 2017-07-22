From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v1 4/6] vmbus: Switch to use new generic UUID API
Date: Sun, 23 Jul 2017 02:46:04 +0800
Message-ID: <201707230246.gWX5xeQF%fengguang.wu@intel.com>
References: <20170719182857.73693-5-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170719182857.73693-5-andriy.shevchenko@linux.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-acpi@vger.kernel.org, devel@linuxdriverproject.org, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-efi@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andy,

[auto build test ERROR on linus/master]
[also build test ERROR on v4.13-rc1]
[cannot apply to next-20170721]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Andy-Shevchenko/uuid-Convert-rest-users-to-new-API/20170723-022330
config: i386-tinyconfig (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

Note: the linux-review/Andy-Shevchenko/uuid-Convert-rest-users-to-new-API/20170723-022330 HEAD f8d40b52dfac11e78d56509455812bcfe9962ce0 builds fine.
      It only hurts bisectibility.

All errors (new ones prefixed by >>):

   In file included from scripts//mod/file2alias.c:44:0:
   scripts//mod/../../include/linux/mod_devicetable.h:408:2: error: unknown type name 'guid_t'
     guid_t guid;
     ^~~~~~
   scripts//mod/../../include/linux/mod_devicetable.h:638:2: error: unknown type name 'guid_t'
     guid_t uuid;
     ^~~~~~
   In file included from scripts//mod/file2alias.c:13:0:
   scripts//mod/file2alias.c: In function 'do_vmbus_entry':
>> scripts//mod/file2alias.c:938:49: error: request for member 'b' in something not a structure or union
      sprintf(&guid_name[i], "%02x", TO_NATIVE((guid->b)[i/2]));
                                                    ^
   scripts//mod/modpost.h:92:23: note: in definition of macro 'TO_NATIVE'
    #define TO_NATIVE(x) (x)
                          ^
   scripts//mod/file2alias.c: In function 'do_mei_entry':
   scripts//mod/file2alias.c:1233:18: error: incompatible type for argument 2 of 'add_uuid'
     add_uuid(alias, *uuid);
                     ^
   scripts//mod/file2alias.c:137:20: note: expected 'uuid_le {aka struct <anonymous>}' but argument is of type 'int'
    static inline void add_uuid(char *str, uuid_le uuid)
                       ^~~~~~~~

vim +/b +938 scripts//mod/file2alias.c

b01d9f28 Rusty Russell    2007-10-22  923  
d2ee52aa K. Y. Srinivasan 2011-08-25  924  /*
d2ee52aa K. Y. Srinivasan 2011-08-25  925   * Looks like: vmbus:guid
d2ee52aa K. Y. Srinivasan 2011-08-25  926   * Each byte of the guid will be represented by two hex characters
d2ee52aa K. Y. Srinivasan 2011-08-25  927   * in the name.
d2ee52aa K. Y. Srinivasan 2011-08-25  928   */
d2ee52aa K. Y. Srinivasan 2011-08-25  929  
6543becf Andreas Schwab   2013-01-20  930  static int do_vmbus_entry(const char *filename, void *symval,
d2ee52aa K. Y. Srinivasan 2011-08-25  931  			  char *alias)
d2ee52aa K. Y. Srinivasan 2011-08-25  932  {
d2ee52aa K. Y. Srinivasan 2011-08-25  933  	int i;
6543becf Andreas Schwab   2013-01-20  934  	DEF_FIELD_ADDR(symval, hv_vmbus_device_id, guid);
6543becf Andreas Schwab   2013-01-20  935  	char guid_name[(sizeof(*guid) + 1) * 2];
d2ee52aa K. Y. Srinivasan 2011-08-25  936  
6543becf Andreas Schwab   2013-01-20  937  	for (i = 0; i < (sizeof(*guid) * 2); i += 2)
af3ff643 K. Y. Srinivasan 2015-12-14 @938  		sprintf(&guid_name[i], "%02x", TO_NATIVE((guid->b)[i/2]));
d2ee52aa K. Y. Srinivasan 2011-08-25  939  
d2ee52aa K. Y. Srinivasan 2011-08-25  940  	strcpy(alias, "vmbus:");
d2ee52aa K. Y. Srinivasan 2011-08-25  941  	strcat(alias, guid_name);
d2ee52aa K. Y. Srinivasan 2011-08-25  942  
d2ee52aa K. Y. Srinivasan 2011-08-25  943  	return 1;
d2ee52aa K. Y. Srinivasan 2011-08-25  944  }
6543becf Andreas Schwab   2013-01-20  945  ADD_TO_DEVTABLE("vmbus", hv_vmbus_device_id, do_vmbus_entry);
d2ee52aa K. Y. Srinivasan 2011-08-25  946  

:::::: The code at line 938 was first introduced by commit
:::::: af3ff643ea91ba64dd8d0b1cbed54d44512f96cd Drivers: hv: vmbus: Use uuid_le type consistently

:::::: TO: K. Y. Srinivasan <kys@microsoft.com>
:::::: CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--1yeeQ81UyVL57Vl7
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICFSZc1kAAy5jb25maWcAjFxbc+M2sn7fX8FKzkPykBnfxnHqlB8gEBQREyRDgJLsF5Yi
a2ZUY0teSU4y//50A6R4ayhnq3Z3jG7c+/J1o6kf//NjwN6Pu9flcbNavrx8D76st+v98rh+
Dj5vXtb/G4RZkGYmEKE0H4A52Wzf//m4ub67DW4+XF5/uPhlv7oMHtb77fol4Lvt582Xd+i+
2W3/8yOw8yyN5LS6vZlIE2wOwXZ3DA7r43/q9sXdbXV9df+983f7h0y1KUpuZJZWoeBZKIqW
mJUmL00VZYVi5v6H9cvn66tfcFk/NBys4DH0i9yf9z8s96uvH/+5u/24sqs82E1Uz+vP7u9T
vyTjD6HIK13meVaYdkptGH8wBeNiTFOqbP+wMyvF8qpIwwp2risl0/u7c3S2uL+8pRl4pnJm
/nWcHltvuFSIsNLTKlSsSkQ6NXG71qlIRSF5JTVD+pgQz4Wcxma4O/ZYxWwmqpxXUchbajHX
QlULHk9ZGFYsmWaFNLEaj8tZIicFMwLuKGGPg/Fjpiuel1UBtAVFYzwWVSJTuAv5JFoOuygt
TJlXuSjsGKwQnX3Zw2hIQk3gr0gW2lQ8LtMHD1/OpoJmcyuSE1GkzEpqnmktJ4kYsOhS5wJu
yUOes9RUcQmz5AruKoY1Uxz28FhiOU0yGc1hpVJXWW6kgmMJQYfgjGQ69XGGYlJO7fZYAoLf
00TQzCphT4/VVPu6l3mRTUSHHMlFJViRPMLflRKde8+nhsG+QQBnItH3V037SUPhNjVo8seX
zZ8fX3fP7y/rw8f/KVOmBEqBYFp8/DBQVVn8Uc2zonMdk1ImIWxeVGLh5tM9PTUxCAMeS5TB
/1SGaexsTdXUGr4XNE/vb9DSjFhkDyKtYDta5V3jJE0l0hkcCK5cSXN/fdoTL+CWrUJKuOkf
fmgNYd1WGaEpewhXwJKZKDRIUq9fl1Cx0mREZyv6DyCIIqmmTzIfKEVNmQDliiYlT10D0KUs
nnw9Mh/hBgin5XdW1V34kG7Xdo4BV0jsvLvKcZfs/Ig3xIAglKxMQCMzbVAC73/4abvbrn/u
3Ih+1DOZc3Jsd/8g/lnxWDEDfiMm+aKYpWEiSFqpBRhI3zVbNWQlOGVYB4hG0kgxqERweP/z
8P1wXL+2Unwy86AxVmcJDwAkHWfzjoxDCzhYDnbE6U3PkOicFVogU9vG0XnqrIQ+YLAMj8Ns
aHq6LCEzjO48A+8QonNIGNrcR54QK7Z6PmsPYOhhcDywNqnRZ4noVCsW/l5qQ/CpDM0crqU5
YrN5Xe8P1CnHT+gxZBZK3pXENEOK9N20JZOUGDwvGD9td1roLo9DV3n50SwP34IjLClYbp+D
w3F5PATL1Wr3vj1utl/atRnJH5w75DwrU+Pu8jQV3rU9z5Y8mq7gZaDHuwbexwpo3eHgT7DA
cBiUldOOudtdD/qjYdY4CnkuODqgsSRBe6qy1MvkkI+Y8gk6F5LNegxATekVrcvywf3Dp4kl
oFTnaACRhE6uKNc9QXUAhjJFwAbOu4qSUsfdTfNpkZW5pk1KLPhDnkkYCQTCZAUtS24R6CDs
WPTBIN6izyJ5ANM3s86tCOl18BO6QNuA8m4xeMoFcUJD7j5WYyk4M5kCsNcDL1LK8LITCaCK
mwQEiovcgiyLwgd9cq7zB1hQwgyuqKU6OewetALbLsHAFvQZArZSIH9VbVlopkcd6bMcgPQA
DI01t/VA0FM/KpqYF3DVDx6JndJd+gdA9wUYVUWlZ8lRacSCpIg88x2EnKYsiWhpsbv30Kzx
9dAmeXT+9GNwriSFSdrds3AmYev1oPSZo0RYv+9ZFcw5YUUh+3LTbAdDiVCEQ6mEIauTE+rc
1eVFD3hYA1uH0fl6/3m3f11uV+tA/LXegkVnYNs52nTwPK3l9Qxeg3okwpaqmbLYntzSTLn+
lTX6PkltQsuCFkidsImHUFIIRifZpLte7A+HW0xFA7x8KmcgtkTQUAEUlpHkNuTy6E8WyWTg
xboXkzmOjhVpWqpUSSe53UX+Xqoc0MhE0BJZR0K0G8f5bAoEAmJQF7TQnAutfWsTEexN4rVA
/NPrMfAseL3owMCHVhM9Z0PML8FPoLuBxZkB6WEYurnWQhiSAGac7uBaMT6KKKsMZzlosQu3
rHGWPQyImKKAv42clllJwDaIwSyQqgEpkRkA02dkBIjCAkmCQQtTQ3PCTUNE/AiAH8Gl9QA2
ATVYYyGmGnxX6BJC9cVULB9uFPcCrU4dB7R4DtokmPPoA5qSC7jvlqztjEMPCbYK2k1ZpAAg
Yceymx0bmh7iGmJWhIhVyhwWaAQ3tTOnBiHmb6xLUZ9CWKqh8NlDbdVmdBVOOirNIgEwO8ec
0WCEutVFvx5amJWedApEZ5WLUZqImlifFhytWwWKb0YnOAX8kiflVKY9+9pp9mkwcNhzQcWz
Z9vDeUMijZz6PHDLqTg7Cl5TmTAa1Iy5QbYz0jyaGOMhOBw5G6m7O11pWdzFRwXEx0M2Iprw
WIEUw0hRJ78wD9XJqWZhmYBpQSMnEpTCsQxpRwFtzNQ4DzhOtA4YxAJsMmlK+r3u+peb5Y9N
JskkPdFop4W10UE/ZlonpTUY1L0ncM0A0/jDHBS0s94MohTAWnUe8XpEYDZR3hMQCPYgtmyd
SRSd8U920TPctb1XGkQhT2YhOEuaDEoxpyGjj5ny8SMbbcDYm06nbhbeSxp2dwJU83TCn8jK
5AgGuywgz2a//Lk8rJ+Dbw6Nve13nzcvvVj6NBFyVw1s6CUhnP2ovZbzarFAQe/kKhGLawRn
95cdkOmknjidRh9MIQSYxAxMd3dfE7TmRDebAoaJclDZMkWmfs6mpltpdvRzNLLvvJBG+Dp3
if3e/VwyMxn63ULNBxyo/3+UosRQHjZhs0R+lmLeMLRhDRzYUx+027vO97vV+nDY7YPj9zeX
P/m8Xh7f9+tD9/HqCTUy7CceW1Cq6CAb8+eRYOCfwcuhhfRzYYarYcW8MM06BT2PpM+mAHYH
ZQgBYHrnEQsDhgMfNc4FiHXeXxaSXoZLMMBNGWf5KwtRPJF0/AgwAeIu8DbTks54g4GaZJlx
TwWtEtzc3dIh2KczBKPpIAdpSi0olbq1D44tJ9hWI0slJT3QiXyeTh9tQ72hqQ+ejT386mm/
o9t5UeqMzg4p6wuEJ2RSc5mC08+5ZyE1+doXHCfMM+5UZKGYLi7PUKuEdiKKPxZy4T3vmWT8
uqKfDCzRc3Yc4iJPLzRDXs2oDbrnJdsqAqaz6udJHcvI3H/qsiSXA1pv+BxcCZgCOpeGDGjn
LJNNB+qyk+VCMihAv6EGybc3w+Zs1m9RMpWqVBYzRBD/JI/9ddsYhptE6R6ShaVg8INoUiQA
KylAAyOCjXcmqpPsr5vt/fZqABoKUyHBDirEymJMsFBSCcPIsUrFXXtrmnIIA22QT152qChw
ltrXYA3u+rR/IVRuRti8aZ9lCSANVtDp1prLK214CLmkbZq9tL6cOJ/WyR297rab427voEs7
aycshDMGAz73HIIVWAHI8hGAocfuegkmAxGf0O5I3tH4EicsBPqDSC58mXAACSB1oGX+c9H+
/cD9yZC62gwfWwZuqG66ofOtNfX2hgqiZkrnCTjJ694rS9uKyNhzoI7lip60Jf/rCJfUumwl
QwaRgDD3F//wC/efgRlilP2xQCsC7AB7rkTKiBoHG237ydZENM+igGa79kAmKGlJAyfwAbAU
9xcn1H+ub7MoxdLS5glatHJakaMR26o790errBV3/TppjXY4iJGM7Bhbl7gRatKHwL3metBR
kq6JEqZlPjixUGoOUWB34H7QVkMnV8+QDnTitGgUhtzYJVjzdTPI7HJ/FjV+BCMRhkVlvDVc
M1mAJc0wpu09v2tFMDcP6za8du+uYXF/c/HbbcdyEFkBf4TpsnYmhrh1znJKs7uFPA89/eaJ
YKn1x3TOxIP5n/Iso7PAT5OSRkdPepyEb4B9ff22bKbJ2PqCJDg/URQYCdnMpFNnfK7reR9R
WMcHMuoPOyyCqCYyw0KVoijzoRD0bLIGHI9B5/z+tiM9yhS0pbWLdlkZ7wLgRPyhkwtoAL3Q
QYhL2tFW+am6vLig8nJP1dWni54KPVXXfdbBKPQw9zDMMCCKC3xfp5/5xEJQ9466JTmYPLin
Ao3x5dAWFwITn/Z1+Vx/+0IA/a8G3etXm1mo6ScxrkIboE980gxmFjPpCYSVxGOcgxu7v9f7
AODG8sv6db092iCa8VwGuzcsAu0F0nXuirY0tKDoSI7mBNkOov36v+/r7ep7cFgtXwYIx4LY
QvxB9pTPL+shs7c0w8oxGhB94sOXsjwR4Wjwyfuh2XTwU85lsD6uPvzcQ16cApXQamtOE2Fr
xrCtqTQJ14fNl+18uV8H2Jfv4B/6/e1tt4c11hcA7WL7/LbbbI+DucALh9adnktDUgkjVwpa
v2h0O3gyAih5JClLPAVSILK0ZqfCfPp0QUeKOUdn6LcnjzqajG5F/LNevR+Xf76sbT1zYMHx
8RB8DMTr+8tyJKMTcKXKYFaZnKgma17InHKGLpWalT17XHfC5nODKunJX2C0iu8rVHTldPx6
WNFXJ9Nk5nxJ93xHRxSu/9pAtBDuN3+51+W2HHKzqpuDbKzOpXs5jkWS+6IoMTMq92Sdweyl
IcN0ty84ssNHslBzAAOuUIdkjeagQCz0LAL97tyWtVDn2FkrPpqHhZx5N2MZxKzwJPMcA2bw
6mHAgEOg7SnUAWDVpsfojF9TggaWB6aVnMwKd7mw7qep7uuEsswVFIdwhFFE5EHRcj1bIejd
rzL0cWcRsQz3aIKV4qe6cIBwdZF8e6muabQCtTmsqCXAbalHTBqTCxEpTzKNaVOEJ8PzaY+6
YLRz4VfkYoSAM1TB4WRo2wktpfrtmi9uR93M+p/lIZDbw3H//mqLNg5fwXI/B8f9cnvAoQJw
VOvgGfa6ecN/NqrGXo7r/TKI8ikDI7V//RsN/vPu7+3LbvkcuFrohlduj+uXAHTb3ppTzoam
uYyI5lmWE63tQPHucPQS+XL/TE3j5d+9nbLq+rg8rgPVgoOfeKbVz0NLg+s7DdeeNY89sGWR
2KcTL5FFZaOAma+aDtjOVNfK8FTsqbmWtWR2JOLk+rRElNQLObHN91qgGAd/nOm4XuC4pFNu
396P4wlbL5zm5VhkY7glKzXyYxZglz7uwprU/5/OWtbeWzdTgtQSDsK9XIHgUnprDJ3xAjPm
K9wC0oOPhqsCoIs2fABZ2nPJlaxcObXnLWJ+LiBJZz4jkfO7X69v/6mmuaeyLNXcT4QVTV2k
5c81Gg7/9eBfiIL48F3PyckVJ8XDU8WqczqDrnNFE2JNt+f5WGZzkwerl93qW2dFzpJuLfCC
SAWVDUMDwB/4wQYGL/ZEAASoHKu0jjsYbx0cv66D5fPzBsHG8sWNevjQ3SEe9UB1T7S5Bzhi
hrNiM0+lpaViiEujM0fHCDyhhTqe+0qQTSwKxejgqimPpzI2etL9TsjZod12szoEevOyWe22
wWS5+vb2stz2QhnoR4w24QAAhsNN9uBaVrvX4PC2Xm0+A85jasJ6QHiQ/XB++v3luPn8vl3h
/TRW6vlkzls7F4UWbdFGEIlFpitBy2psEDtAbHvt7f4gVO4Bg0hW5vb6N8/TD5C18oUYbLL4
dHFxfukYCvte0IBsZMXU9fWnBb7GsNDzIomMymMzXBmP8aBCJULJmoTQ6IKm++XbVxQUwjaE
/SdfBz14HvzE3p83O/Dcp/fwn/1fcsIg6DkJW2q5ov3ydR38+f75MziGcOwYIlpxsd4lsY4o
4SG1uRPnbMowr+UB1VmZUsn9EhQqizHOlsZACA+BsWSdcjCkjz7pxMZToUfMe06+1ONIE9ss
ynvuwxtsz79+P+D3tUGy/I4ec6wxOBsYRdrDZLmlL7iQM5IDqVMWTonozk5vszTh+gWn/W4N
sfn+tv6FUysxEJXwquQeB4BTlUkuvZ64nNN3rJRHF4TS3uRZKiC2EyE9k6u8lBMJ1/pIXLsI
GW8iYYjYy873kpY0uvICLA8Id79B8cub27vLu5rSqqnBr4iY9gSDihExm4u3FYNAjEyQPaYc
KxE9yahyEUqd+z7eKD3mxObnfXBzttnDKigxwG4yg1vrD1uHa6v97rD7fAxiEKP9L7Pgy/sa
ggjC6LgYF22hN40P+jwdFGr3EjtNvQoVBLeIPobITJx4PYVu86aAaAxnLX7Ru/d9z6M1oycP
uuCVvLv61Km8g1YxM0TrJAlPre31GSWSKpee4vbYIcSKq39hUKakSxdOHEbRn00JVTOAvnnC
E5lMMjozJzOlSq/fKdavu+MaQz9KljAPYjB25uOOb6+HL0OTqYHxJ20/MwuyLYQam7efW6Qy
CB9PUEbv+HCgzQe1GLS3x1WmC+lPDsAaKs8xIenJ44JyK6bD7HN7BQvjBQ/2bZM+e49q53Pq
jY2BqkzB5Cm2qNKiW1soc6zY9RluC4Ft9X2RJb4wKlLjO0S/1f0ucJTB8jk2wJjVQ5YydCpX
Xi6MFfIFq67uUoVxCe1Gelw4nh/Mc8/Dk+Jjr07UU1BmrmBj28q2z/vd5rnLBqCpyCQNXEPm
SYl7Q2Zt6Hb3eGbi0YpshqkH7TrPCe0VI9eoK8ABYt+RByXYL+zyRCyIdGPUpLjCsVKK0JPi
bbLAcBa+d8NQJElVTGjbF/JwwnyVldk0EacpiMTel/2yk5jrZb4ifFRwkt/xF6Er8oJQt/Ph
TufQ6o8DGadjQ7FAIwtsrm7Al8WyVcfI4fOeMIJIefE4etvtcNiPRzzZmjM06WiV9yvKiJ3p
/UeZGTpDZinc0OeC+e1I31SeF4UIy+M8tAzgDyCnAdmJ3nL1dRCl6FFRgDMGh/X7884+JLVX
3toW8G++6S2NxzIJC0HfBBa0+15K8FtTGtC43wE5T628yMv9H0iJZwB8kbJS5j69o5nSZHyk
9YeMX5erb/2P0O2v58jijyhhU90B4LbX236zPX6z4cnz6xpgQQuR2wXrzAr91P6OSFNPcv/r
qaIXdA1rIkYcN/Vl717f4Pp+sV/Mw72vvh3shCvXvqdguXvYwRobWlttsVMFtgN/pygvBIf4
1PPNq2NVpf0hGUHW67uyahzt/vLi6qZr7guZV0yryvvVMBbq2xmYpl1DmYKOYA5DTTLPV7Cu
Qmyenn0Gi6inqFjgI5x2Oxt/kKqF+y0nkCqFyS9a1gdM7lizNKECvPZbr14t+qD4/9+q1Osd
ZfZHKwR7aIqFPBAZoRXoQ/9NqjeU+zalkWoF0BiC7nD95/uXL8NaTDxrW5ivfRZ68As9/iuD
Leos9bkCN0yR2a9nh78+M+DKJr/DLXi/bas3CZ44gdMa33NDOTOD+3Ss1D7D5LhmNLqtUzI1
D4Spg6K/HuHM8HUxIVZPnd+qXS06kCixP49CbaYh+0ayy8aT8SlHPHjlrJ/mQWiCBELT9zdn
p+Ll9ks/jMkiM/iOk3YG4+89PWeDxP9r5Fqa4oZh8F/h2EOnA6XT6TXJesHs4oQ8WJZLpu3s
YQ99zAIz5d9XDydOHMlwg5WSOLYsK5K+D84OxywcotLuTsxfTwzSwS6BbVxGsYskj3s9WYhf
qthHsWi1Uv0wi9m0kGpr4WCjKccnbIypJKoTnPKwZc8+PP09/qZaxMezXy/Ph38H+AP7ez7N
O3z8WgpJhtj2kGkh2Uew27ESouV3VdbK7pJ1KUpMuIe6vE8HinQDzKsmHjIk0rYwZW+MBR5D
yOfGbNc6ookeCmY4Ap9kUxvnwd9MyyF5bj75JniIIF9M5xpjEASVqAV6L8ZeMPWmGqWMd9n2
LY0m5aoHUHfKRooa3sW1NhNCMOTOkc8csgaNWufN9UBaHYIQJDXedRt9vYg+6M77+NQm8QRV
fa2f2MNE9qauyxrcx43RG565O1nUGSKoEfOuUEGSu193rghMNTGufJRe1Vl1LesMPAQiq8Jc
SIBsCaTvxbeMd4XAFL5HIxXf2MljYLqBGGjvL+S7BCFegRs9TECYxcXKskkiJxWE3e3h6Tky
Suqawu1CfH2yZZqUNA8Lgohw3e5ygs+qcgoT4UDq02rsDL9+SXslGvK1eVCbzvidIK53V76P
Tt7upLcBxVbJzpICcQbJfYskz22r5U5I3nVKaoqkNSLaF83I0btqoPcZF0ZiBCuVmwpCJ3We
KWh1zAwjN7OHgyK7rWR49SRMu1rNKj34fyoS7fImc3BnCCSR6Ipx4MFUAkqBFV3ZO42BiTTS
Ue89AT4a7ms0s7IkVksgDs3LhqEhCgEYIw0SDFNUdWnRavVSeNBJ+WfZWpmzQ2f68fHZNieK
NHmfcjkCdqlOo4O1K8VJ25JpZ6na2Z8/fDsP8Wcsgzm+kGVsroHLdC4lUODlQkYPm/ZVB4GS
NRg1Ettj1HFRQ+04pf5omw5xGlwXVbbcnV42crhN6GSjxYIwRClejPDRfq2c0FWHZKroUpcj
4HrQ4efL6fj8KiVnNmavZM1M0dW23YPvMQ1VN4gVIqmrJRZnnEJaANrCgYzRAaLTlk3R0TqE
0WUTGFksnXPHYiJXJ369n0Gb/OevfdQpsnLrsnovnBr8BXT8cfp+ej07/XmBw/owScKNXExt
7Ypq36+xJxZfPLzHVGVrnCJdWzeQL+dW4N5EDMPQwR6J1J8FNhAiWPAFCTsn9Srqoi8K28pW
AdILGdyK17UX5ysrn7Yoti0EuJr0Uq5OgUQmBwCB3M60tTndTuOhLWSSAGKO9XysjCAQkO0h
ZqJvpcvP6WDn4RFZ2hOiPi9uROttcDmnEEz+CT12DJdsPEn5LLBwZVmpRRJUoBYItRcYYlvl
xVcrOUdCLLoqIaKHXGrCGDwYm2uDzQyZdYIl44E20ob+Byne95S7XwAA

--1yeeQ81UyVL57Vl7--
