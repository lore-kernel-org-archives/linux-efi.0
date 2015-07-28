From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH 01/16] PM / hibernate: define HMAC algorithm and
 digest size of swsusp
Date: Tue, 28 Jul 2015 14:01:56 +0200
Message-ID: <20150728120156.GB9518@amd>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-2-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437056730-15247-2-git-send-email-jlee@suse.com>
Sender: linux-pm-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

On Thu 2015-07-16 22:25:15, Lee, Chun-Yi wrote:
> Using HMAC-SHA1 to be the HMAC algorithm of signing hibernate
> snapshot image. The digest size of HMAC-SHA1 is 160 bits (20 bytes),
> this size will be also applied to the length of HMAC key.
> 
> In addition, add HIBERNATE_VERIFICATION kernel config.
> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  include/linux/suspend.h |  5 +++++
>  kernel/power/Kconfig    | 13 +++++++++++++
>  kernel/power/power.h    |  1 +
>  3 files changed, 19 insertions(+)
> 
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index 5efe743..6cd2a48 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -327,6 +327,11 @@ struct platform_hibernation_ops {
>  };
>  
>  #ifdef CONFIG_HIBERNATION
> +
> +/* HMAC Algorithm of Hibernate Signature */
> +#define SWSUSP_HMAC		"hmac(sha1)"
> +#define SWSUSP_DIGEST_SIZE	20

I'd replace SWSUSP with HIBERNATION here, and pretty much everywhere.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
