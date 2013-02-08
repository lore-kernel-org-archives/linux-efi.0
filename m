From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3 v3] selftests: Add tests for efivarfs
Date: Fri, 08 Feb 2013 10:08:49 +0000
Message-ID: <1360318129.7515.278.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1360162088.142733.191120808822.0.gpush@pecola>
	 <1360162088.143076.913706486688.1.gpush@pecola>
	 <20130207151333.f01d415c.akpm@linux-foundation.org>
	 <5114CE00.6050307@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5114CE00.6050307-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-02-08 at 18:05 +0800, Jeremy Kerr wrote:
> However, the tests expose a bug at the moment, so run_tests will fail. 
> Matt will have that fixed soon though :)

In which case, would it make more sense for me to take these tests
through the efi tree? I'm fine either way, I'm just looking for the
least surprising option.
