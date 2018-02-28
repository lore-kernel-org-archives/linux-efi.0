From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 0/8] Decode IA32/X64 CPER
Date: Wed, 28 Feb 2018 09:43:21 +0100
Message-ID: <20180228084321.GA2969@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yazen Ghannam <Yazen.Ghannam@amd.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 26, 2018 at 01:38:56PM -0600, Yazen Ghannam wrote:
> From: Yazen Ghannam <yazen.ghannam@amd.com>
> 
> This series adds decoding for the IA32/X64 Common Platform Error Record.

One much more important thing I forgot about yesterday: how is
this thing playing into our RAS reporting, x86 decoding chain, etc
infrastructure?

Is CPER bypassing it completely and the firmware is doing everything
now? I sure hope not.

If not, it needs to tie into our infrastructure and the errors need
to go into the decoding chain where different things look at them and
filter them.

Tony, what are your plans here?

Perhaps we can finally get MCE decoding on Intel too :-)

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
