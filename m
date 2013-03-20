From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Tue, 19 Mar 2013 18:05:35 -0700
Message-ID: <51490B5F.7070909@zytor.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com> <51490ABD.3050205@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <51490ABD.3050205@zytor.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 03/19/2013 06:02 PM, H. Peter Anvin wrote:
> 
> Looking at it in detail, EVERYTHING in CAP_SYS_RAWIO has the possibility
> of compromising the kernel, because they let device drivers be bypassed,
> which means arbitrary DMA, which means you have everything.
> 

Well, *unless* you have an iommu that you *actually know* is protecting you.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

