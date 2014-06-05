From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] x86/efi: Only pass mapped RAM regions to free_bootmem_late()
Date: Thu, 05 Jun 2014 07:43:44 -0700
Message-ID: <53908220.4030208@intel.com>
References: <1401974854-7716-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401974854-7716-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Fleming <matt.fleming@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On 06/05/2014 06:27 AM, Matt Fleming wrote:
> free_bootmem_late() expects to only be passed RAM regions that the
> kernel can access, and that have a corresponding 'struct page'. It's
> possible for regions in the EFI memory map to reside in address ranges
> for which pfn_to_page() doesn't work, for instance when running on an
> i386 system with CONFIG_HIGHMEM=n.

FWIW, I think there are also a bunch of ways to hit this if someone uses
mem=, even on 64-bit.
