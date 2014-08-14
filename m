From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v2] firmware: Do not use WARN_ON(!spin_is_locked())
Date: Thu, 14 Aug 2014 09:54:09 +0100
Message-ID: <20140814085409.GX15082@console-pimps.org>
References: <1407954094-26126-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407954094-26126-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 13 Aug, at 11:21:34AM, Guenter Roeck wrote:
> spin_is_locked() always returns false for uniprocessor configurations
> in several architectures, so do not use WARN_ON with it.
> Use lockdep_assert_held() instead to also reduce overhead in
> non-debug kernels.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Use lockdep_assert_held instead of WARN_ON_SMP.
> 
>  drivers/firmware/efi/vars.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Thanks Guenter, applied!

-- 
Matt Fleming, Intel Open Source Technology Center
