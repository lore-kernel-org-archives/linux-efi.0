From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] x86, efi: add efi_whitelist_table to use all efi
 variable storage
Date: Tue, 3 Dec 2013 03:45:27 +0000
Message-ID: <25e63f3b748741998d2b3e04bbc53064@BN1PR05MB423.namprd05.prod.outlook.com>
References: <528C740A.6010407@jp.fujitsu.com>
  <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>
  <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com>
  <1385078632.12107.3.camel@x230> <528EF87D.4050300@jp.fujitsu.com>
  <528EF9CE.2070305@jp.fujitsu.com>
 <1385142450.2884.1.camel@x230>,<529D4DF5.80502@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <529D4DF5.80502-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "richard-/L3Ra7n9ekc@public.gmane.org" <richard-/L3Ra7n9ekc@public.gmane.org>, "cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The threshold of 5K is based on information we received from vendors. We won't be reducing it. Can you confirm that attempting to create a variable larger than the remaining space in boot services will trigger garbage collection?--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
