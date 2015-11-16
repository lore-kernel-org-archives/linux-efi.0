From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 07/12] ARM: split off core mapping logic from
 create_mapping
Date: Mon, 16 Nov 2015 18:55:19 +0000
Message-ID: <20151116185519.GE8644@n2100.arm.linux.org.uk>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
 <1447698757-8762-8-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1447698757-8762-8-git-send-email-ard.biesheuvel@linaro.org>
Sender: owner-linux-mm@kvack.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, matt.fleming@intel.com, will.deacon@arm.com, grant.likely@linaro.org, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, roy.franz@linaro.org, msalter@redhat.com, ryan.harkin@linaro.org, akpm@linux-foundation.org, linux-mm@kvack.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 16, 2015 at 07:32:32PM +0100, Ard Biesheuvel wrote:
> In order to be able to reuse the core mapping logic of create_mapping
> for mapping the UEFI Runtime Services into a private set of page tables,
> split it off from create_mapping() into a separate function
> __create_mapping which we will wire up in a subsequent patch.

I'm slightly worried about this.  Generally, these functions setup
global mappings.  If you're wanting to have a private set of page
tables for UEFI, and those private page tables contain global
mappings which are different from the mappings in the kernel's page
tables, then you need careful break-TLBflush-make handling when
switching from the kernel's page tables to the private UEFI ones,
and vice versa.

Has this aspect been considered?

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
