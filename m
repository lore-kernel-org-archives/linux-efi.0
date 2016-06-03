From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/3] arm64: efi: Ensure efi_create_mapping() does not map
 overlapping regions
Date: Fri, 3 Jun 2016 21:56:39 +0100
Message-ID: <20160603205639.GO2658@codeblueprint.co.uk>
References: <1464707672-21882-1-git-send-email-catalin.marinas@arm.com>
 <1464707672-21882-3-git-send-email-catalin.marinas@arm.com>
 <20160602145246.GH2658@codeblueprint.co.uk>
 <20160602165621.GD24938@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160602165621.GD24938-M2fw3Uu6cmfZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 02 Jun, at 05:56:21PM, Catalin Marinas wrote:
> 
> Ard to confirm but I think the reason is the relative offset between
> code and data regions that must be preserved. For example, on Juno I
> get:
> 
> [    0.000000] efi:   0x0009fff6e000-0x0009fffaefff [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0009fffaf000-0x0009ffffefff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
> 
> Since the code may assume relative loads from the data section, we need
> to preserve this offset (which doesn't seem 64KB aligned).

Yeah, figures. Could you mention this in the changelog or in a code
comment?
