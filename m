From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: Add necessary checks before iterating over
 efi.memmap
Date: Tue, 20 Sep 2016 10:56:18 +0100
Message-ID: <20160920095618.GH2892@codeblueprint.co.uk>
References: <20160913032813.GA11652@localhost.localdomain>
 <20160920052514.GA41801@g.c>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160920052514.GA41801@g.c>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Gao <chao.gao@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 20 Sep, at 01:25:14PM, Chao Gao wrote:
> Sorry for bothering you. There is a regression since commit 78ce248f that if
> booting xen in UEFI mode, dom0 will crash and xen reboot constantly.
> This patch tries to fix it. Please take a look at it.

Can you try commit d4c4fed08f31 ("efi: Make
for_each_efi_memory_desc_in_map() cope with running on Xen") and see
if that fixes things for you?

That patch is already in Linus' tree and is included in v4.8-rc7.
