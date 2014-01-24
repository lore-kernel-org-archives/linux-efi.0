From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC][PATCH 3/3] ia64/efi: Implement efi_enabled()
Date: Fri, 24 Jan 2014 18:46:39 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31DB855E@ORSMSX106.amr.corp.intel.com>
References: <1389796136-23479-1-git-send-email-matt@console-pimps.org>
 <1389796136-23479-4-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389796136-23479-4-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Tony-hKmkhVXvusEnkhFzW7PF62O9nC1t1/YaHZ5vskTnxNA@public.gmane.org" <Tony-hKmkhVXvusEnkhFzW7PF62O9nC1t1/YaHZ5vskTnxNA@public.gmane.org>, "\"Luck <tony.luck\"@intel.com" <"Luck <tony.luck"@intel.com>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> There's no good reason to keep efi_enabled() under CONFIG_X86 anymore,
> since nothing about the implementation is specific to x86.

Reviewed-and-tested-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
