From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: split efi systab in sysfs
Date: Wed, 25 Dec 2013 17:55:27 -0800
Message-ID: <52BB8C8F.1020606@zytor.com>
References: <20131226015308.GA3750@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131226015308.GA3750-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
Cc: greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/25/2013 05:53 PM, Dave Young wrote:
> Hi, Matt and Peter
> 
> Currently /sys/firmware/efi/systab contains multi-lines for efi systab
> entries. As previous discussion with Greg, this is not a good in sysfs.
> I wonder if there's other users for this file except kexec-tools.
> 
> If kexec-tools is the only user, maybe I can split it as several files.
> In kexec-tools just use /sys/firmware/efi/"$entry_name" and if $entry_name
> does not exist then switch to old systab file. 
> 

Yes, the sysfs standard is "one entry per datum".  I have no idea about
who the user(s) might be, though.

	-hpa
