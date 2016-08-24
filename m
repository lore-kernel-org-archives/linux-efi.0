From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 0/6] Apple device properties
Date: Wed, 24 Aug 2016 20:49:05 +0100
Message-ID: <20160824194905.GA4551@codeblueprint.co.uk>
References: <cover.1469616641.git.lukas@wunner.de>
 <20160804145710.GL3636@codeblueprint.co.uk>
 <20160809133816.GA6571@wunner.de>
 <20160815115414.GE30909@codeblueprint.co.uk>
 <20160815161358.GA9603@wunner.de>
 <20160818203433.GP30909@codeblueprint.co.uk>
 <20160822095850.GA22131@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160822095850.GA22131@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, 22 Aug, at 11:58:50AM, Lukas Wunner wrote:
> By the way, arch/x86/Kconfig says that "it is not possible to boot a
> mixed-mode enabled kernel via the EFI boot stub - a bootloader that
> supports the EFI handover protocol must be used".
> 
> Is this still correct? With all the mixed-mode support in head_64.S
> and eboot.c, I'm wondering what's missing?

Yes, that's still correct.

The EFI boot stub technically refers to the feature of having the
firmware load the kernel directly, without the use of a boot loader.

In that scenario you need the kernel and firmware to agree on a CPU
mode since the kernel has no way to figure out if it needs to switch
or not. Nor does it have a direct way to figure out what bitness the
firmware is.

[ Yes, technically we could add code to the EFI stub to detect the
  current mode and perform the switch, we just don't have anything
  like that right now ]
