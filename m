From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/3 v3] selftests: Add tests for efivarfs
Date: Tue, 12 Feb 2013 15:50:05 -0800
Message-ID: <20130212155005.36f9a718.akpm@linux-foundation.org>
References: <1360162088.142733.191120808822.0.gpush@pecola>
	<1360162088.143076.913706486688.1.gpush@pecola>
	<20130207151333.f01d415c.akpm@linux-foundation.org>
	<5114CE00.6050307@ozlabs.org>
	<1360318129.7515.278.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360318129.7515.278.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 08 Feb 2013 10:08:49 +0000
Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, 2013-02-08 at 18:05 +0800, Jeremy Kerr wrote:
> > However, the tests expose a bug at the moment, so run_tests will fail. 
> > Matt will have that fixed soon though :)
> 
> In which case, would it make more sense for me to take these tests
> through the efi tree? I'm fine either way, I'm just looking for the
> least surprising option.

I don't think it matters much at this stage.  selftests is new and is
used by approximately zero people so if the tests fail, few will
notice.  Let's just get it in there and get it settled down.
