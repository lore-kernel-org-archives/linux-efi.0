From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Tue, 19 Mar 2013 19:48:25 -0700
Message-ID: <51492379.3090302@zytor.com>
References: <3pfl8u1ugprwkcs5xmtjth3l.1363742692541@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <3pfl8u1ugprwkcs5xmtjth3l.1363742692541@email.android.com>
Sender: linux-pci-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 03/19/2013 06:28 PM, Matthew Garrett wrote:
> Mm. The question is whether we can reliably determine the ranges a device should be able to access without having to trust userspace (and, ideally, without having to worry about whether iommu vendors have done their job). It's pretty important for PCI passthrough, so we do need to care. 

It is actually very simple: the device should be able to DMA into/out of:

1. pinned pages
2. owned by the process controlling the device

... and nothing else.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
