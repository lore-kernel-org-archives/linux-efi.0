From: Steve Capper <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/6] arm64/mm: add explicit struct_mm argument to
 __create_mapping()
Date: Fri, 24 Oct 2014 16:23:28 +0100
Message-ID: <20141024152324.GB22807@linaro.org>
References: <1414154384-15385-1-git-send-email-ard.biesheuvel@linaro.org>
 <1414154384-15385-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414154384-15385-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 24, 2014 at 02:39:39PM +0200, Ard Biesheuvel wrote:
> Currently, swapper_pg_dir and idmap_pg_dir share the init_mm mm_struct
> instance. To allow the introduction of other pg_dir instances, for instance,
> for UEFI's mapping of Runtime Services, make the struct_mm instance an
> explicit argument that gets passed down to the pmd and pte instantiation
> functions. Note that the consumers (pmd_populate/pgd_populate) of the
> mm_struct argument don't actually inspect it, but let's fix it for
> correctness' sake.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Acked-by: Steve Capper <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
