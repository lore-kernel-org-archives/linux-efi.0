From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 0/4] Apple device properties
Date: Tue, 13 Sep 2016 12:29:21 +0100
Message-ID: <20160913112921.GH3872@codeblueprint.co.uk>
References: <cover.1473242067.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1473242067.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, grub-devel-mXXj517/zsQ@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 07 Sep, at 12:49:18PM, Lukas Wunner wrote:
> Retrieve device properties from EFI on Macs before ExitBootServices is
> called and assign them to devices (patch [3/4]). The devices that
> properties pertain to are encoded as EFI Device Paths, so add a parser
> for these (patch [2/4]). As a first use case, amend the Thunderbolt driver
> to take advantage of the Device ROM supplied by EFI (patch [4/4]).
> 
> Patch [1/4] is already queued in Rafael J. Wysocki's tree for 4.9 and is
> included here only because patch [2/4] wouldn't compile without it.
> 
> The series also depends on these two patches which are already queued
> in Matt's tree for 4.9:
> 
> - x86/efi: Optimize away setup_gop32/64 if unused
>   https://patchwork.kernel.org/patch/9315763/
> 
> - x86/efi: Allow invocation of arbitrary boot services
>   https://patchwork.kernel.org/patch/9293371/

I had a quick look over these series and nothing looks too crazy, but
I still need to do an in-depth review.

Given the patch dependencies you outlined above, could you resubmit
this after the v4.9 merge window closes? That way it won't be
forgotten about.
