From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 10/17] Renames in handle_cmdline_files() to complete
 generalization.
Date: Wed, 7 Aug 2013 14:09:44 +0100
Message-ID: <20130807130944.GE2515@console-pimps.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
 <1375847113-24884-11-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375847113-24884-11-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com, linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
List-Id: linux-efi@vger.kernel.org

On Tue, 06 Aug, at 08:45:06PM, Roy Franz wrote:
> Rename variables to be not initrd specific, as now the function
> loads arbitrary files.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   92 ++++++++++++++++----------------
>  1 file changed, 46 insertions(+), 46 deletions(-)

This looks nice, thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
