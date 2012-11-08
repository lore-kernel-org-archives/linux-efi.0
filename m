From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: Do not allow MSR or Embedded Controller writes from userspace
 in secure boot case
Date: Thu, 8 Nov 2012 14:47:14 +0000
Message-ID: <20121108144714.GA24764@srcf.ucam.org>
References: <1352323699-52400-1-git-send-email-trenn@suse.de>
 <20121107215403.GA7277@srcf.ucam.org>
 <509AE5DA.1030508@zytor.com>
 <201211081538.34091.trenn@suse.de>
 <20121108144125.GC24094@srcf.ucam.org>
 <509BC53B.5070304@shealevy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <509BC53B.5070304-yfkUTty7RcRWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shea Levy <shea-yfkUTty7RcRWk0Htik3J/w@public.gmane.org>
Cc: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 08, 2012 at 09:44:11AM -0500, Shea Levy wrote:

> How is secureboot_enable=no ok? Unless we're disabling efivarfs in
> secureboot mode root can change the kernel command line.

What do you mean by "ok"? Ubuntu ship a signed kernel without requiring 
signed modules, so any in-kernel protections can be trivially 
circumvented. They've made that decision based on a risk/benefit 
analysis. Every vendor is going to have to make their own analysis, and 
it's not guaranteed that the upstream kernel is going to precisely match 
any of them.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
