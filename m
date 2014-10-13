From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 2/2] efi: Capsule update support
Date: Mon, 13 Oct 2014 10:53:10 +0100
Message-ID: <20141013095310.GZ14343@console-pimps.org>
References: <CAGBcZGfHX57jwCfw7CnvLgOJ58kd0KVJULOvhAsfi=3YBp5WsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGBcZGfHX57jwCfw7CnvLgOJ58kd0KVJULOvhAsfi=3YBp5WsQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Leif Lindholm <leif.lindholm@linaro.org>, hock.leong.kweh@intel.com, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, 10 Oct, at 06:55:49PM, Sam Protsenko wrote:
> Hi Matt,
> 
> 1. Why x86 code isn't separated to another patch?

When I originally wrote this patch in 2013 arm64 support didn't exist,
and ia64 isn't going to be using capsule support. I can separate that
out into a separate patch though, no problem.

> 2. drivers/firmware/efi/reboot.c: efi_reboot():
>     One shouldn't use "printk()" with no KERN_* stuff passed into it.
> I'd recommend to use "pr_info()" macro or something like that.

Oops, I missed that, good catch.

Next time, could you please quote the part of the patch you're
commenting on inline? That would have saved me searching through the
original email.

-- 
Matt Fleming, Intel Open Source Technology Center
