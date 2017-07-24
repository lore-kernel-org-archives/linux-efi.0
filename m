From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v1 5/6] uuid: Kill uapi/uuid.h
Date: Mon, 24 Jul 2017 17:54:41 +0200
Message-ID: <20170724155441.GC17917@lst.de>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <20170719182857.73693-6-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170719182857.73693-6-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org, sparmaintainer-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-watchdog-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 29d6699d5a06..1c68709123aa 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -36,7 +36,7 @@ typedef uint16_t	__u16;
>  typedef unsigned char	__u8;
>  typedef struct {
>  	__u8 b[16];
> -} uuid_le;
> +} guid_t;
>  
>  /* Big exception to the "don't include kernel headers into userspace, which
>   * even potentially has different endianness and word sizes, since
> @@ -134,7 +134,7 @@ static inline void add_wildcard(char *str)
>  		strcat(str + len, "*");
>  }
>  
> -static inline void add_uuid(char *str, uuid_le uuid)
> +static inline void add_uuid(char *str, guid_t uuid)
>  {
>  	int len = strlen(str);

This should probably be split into a separate patch.
