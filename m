From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: access efi variables
Date: Fri, 13 Sep 2013 15:37:15 -0700
Message-ID: <5233939B.3020401@zytor.com>
References: <52333139.6020203@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52333139.6020203-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arend van Spriel <arend-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/13/2013 08:37 AM, Arend van Spriel wrote:
> I need to obtain a uefi variable so I went looking at the API in
> include/linux/efi.h. I found the following definition:
> 
> But according to the specs the variable I need to obtain is 2k bytes.
> Should I expect trouble :-p
> 

efivarfs doesn't have those limitations.

	-hpa
