From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Remove redundant and incorrect memset()
Date: Fri, 4 Oct 2013 19:33:10 +0200
Message-ID: <20131004173310.GA15689@gmail.com>
References: <20131003131054.GB27835@gmail.com>
 <1380902566-30867-1-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1380902566-30867-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, matt.fleming@intel.com, hpa@zytor.com, msalter@redhat.com, patches@linaro.org
List-Id: linux-efi@vger.kernel.org


* Roy Franz <roy.franz@linaro.org> wrote:

> Remove a redundant memset() call from efi_relocate_kernel() that
> was clearing memory that would be used by BSS in non-compressed
> images loaded with this function.  This clear was redundant with
> the clearing done in the image itself, and also implemented incorrectly
> with a 0 length.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> Acked-by: Mark Salter <msalter@redhat.com>

Note the title:

   [PATCH] Remove redundant and incorrect memset()

if it's both redundant *and* incorrect then the other memset() must be 
incorrect too and must be removed as well ;-)

I suspect you wanted the title to say:

   [PATCH] Remove redundant memset()

?

Thanks,

	Ingo
