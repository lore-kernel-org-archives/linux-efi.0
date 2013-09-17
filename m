From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: access efi variables
Date: Tue, 17 Sep 2013 16:46:30 +0100
Message-ID: <20130917154630.GG3409@console-pimps.org>
References: <52333139.6020203@broadcom.com>
 <5233939B.3020401@zytor.com>
 <5234965F.3050404@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5234965F.3050404-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arend van Spriel <arend-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 14 Sep, at 07:01:19PM, Arend van Spriel wrote:
> On 09/14/13 00:37, H. Peter Anvin wrote:
> >On 09/13/2013 08:37 AM, Arend van Spriel wrote:
> >>I need to obtain a uefi variable so I went looking at the API in
> >>include/linux/efi.h. I found the following definition:
> >>
> >>But according to the specs the variable I need to obtain is 2k bytes.
> >>Should I expect trouble :-p
> >>
> >
> >efivarfs doesn't have those limitations.
> 
> Thanks, Peter
> 
> Looking into efivarfs it seems to use the functions that I looked at
> in efi.h so I guess I am misinterpreting the 1024 bytes limitation
> in the comment (either that or you are mistaken ;-) ). I need to
> access the variable from within a device driver so using efivarfs
> does not feel like the way to go here.

Look at how efivarfs_file_read() is implemented, e.g. using
efivar_entry_get(). In particular, note how it kmalloc()'s a buffer for
reading the variable data into, thereby avoiding any 1024-byte
limitation.

-- 
Matt Fleming, Intel Open Source Technology Center
