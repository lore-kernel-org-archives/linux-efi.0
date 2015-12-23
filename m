From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/4] x86/efi: show actual ending addresses in
 efi_print_memmap
Date: Wed, 23 Dec 2015 12:44:39 +0000
Message-ID: <20151223124439.GA2471@codeblueprint.co.uk>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-2-git-send-email-elliott@hpe.com>
 <20151221155038.GD4227@codeblueprint.co.uk>
 <20151221160629.GF4227@codeblueprint.co.uk>
 <94D0CD8314A33A4D9D801C0FE68B40295BEC74CF@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BEC74CF@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 22 Dec, at 08:08:19PM, Elliott, Robert (Persistent Memory) wrote:
> 
> While investigating the grub persistent memory corruption
> issues, it was helpful to make this table match the ending
> address convention used by:
> * the kernel's e820 table prints
> * the kernel's nosave memory prints
> * grub's lsmmap and lsefimmap commands
> * the UEFI shell's memmap command
> 
> Using the excerpts from the patch, if you grep all the various
> logs for c7fffffff, you won't find the line with c80000000.

I like this. This is reasonable justification. Please inclue it in the
commit log.
