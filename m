From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 5/8] arm: convert to generic builtin command line
Date: Wed, 24 Oct 2018 10:16:00 +0100
Message-ID: <20181024091600.GT30658@n2100.armlinux.org.uk>
References: <1538067393-5926-1-git-send-email-maksym.kokhan@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1538067393-5926-1-git-send-email-maksym.kokhan@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maksym Kokhan <maksym.kokhan@globallogic.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Walker <dwalker@fifo99.com>, Daniel Walker <danielwa@cisco.com>, Andrii Bordunov <aborduno@cisco.com>, Ruslan Bilovol <rbilovol@cisco.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 27, 2018 at 07:56:33PM +0300, Maksym Kokhan wrote:
> From: Daniel Walker <danielwa@cisco.com>
> 
> This updates the arm 32bit code to use the CONFIG_GENERIC_CMDLINE
> option.

Sorry, I can't accept this change.  While it may seem to be a good idea
to unify this between different architectures, the problem this presents
is that it breaks people's existing .config, and almost every single
defconfig that we have in arch/arm/configs/

The breakage is such that it will end up wiping out (eg) the setting of
CONFIG_CMDLINE entirely, and only if it's realised and retrieved
immediately from .config.old, it will be lost.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
