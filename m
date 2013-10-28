From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH] Differentiating names by adding a timestamp.
Date: Mon, 28 Oct 2013 15:46:01 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D0EFB@USINDEM103.corp.hds.com>
References: <87li1dv8by.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87li1dv8by.fsf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anton Vorontsov <cbou-JGs/UdohzUI@public.gmane.org>, Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <kees-oSa+0FWJbaXR7s880joybQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

To distinguish all events more precisely, "count" is needed to add to the name.
Please see the commit below.
755d4fe46529018ae45bc7c86df682de45ace764

Seiji

> -----Original Message-----
> From: Madper Xie [mailto:cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Monday, October 28, 2013 9:22 AM
> To: Tony Luck; Seiji Aguchi; Anton Vorontsov; Colin Cross; Kees Cook
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] Differentiating names by adding a timestamp.
> 
> 
> pstore denominate dumped file as type-psname-id. it makes many file have
> the same name if there are many entries in backend have the same id.
> So adding a timestamp to file name.
> 
> Signed-off-by: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/pstore/inode.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index 1282384..bf6ed3a 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -315,32 +315,38 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
> 
>  	switch (type) {
>  	case PSTORE_TYPE_DMESG:
> -		sprintf(name, "dmesg-%s-%lld%s", psname, id,
> -						compressed ? ".enc.z" : "");
> +		sprintf(name, "dmesg-%s-%lld-%lld%s", psname, id,
> +			timespec_to_ns(&time), compressed ? ".enc.z" : "");
>  		break;
>  	case PSTORE_TYPE_CONSOLE:
> -		sprintf(name, "console-%s", psname);
> +		sprintf(name, "console-%s-%lld", psname, timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_FTRACE:
> -		sprintf(name, "ftrace-%s", psname);
> +		sprintf(name, "ftrace-%s-%lld", psname, timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_MCE:
> -		sprintf(name, "mce-%s-%lld", psname, id);
> +		sprintf(name, "mce-%s-%lld-%lld", psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_PPC_RTAS:
> -		sprintf(name, "rtas-%s-%lld", psname, id);
> +		sprintf(name, "rtas-%s-%lld-%lld", psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_PPC_OF:
> -		sprintf(name, "powerpc-ofw-%s-%lld", psname, id);
> +		sprintf(name, "powerpc-ofw-%s-%lld-%lld", psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_PPC_COMMON:
> -		sprintf(name, "powerpc-common-%s-%lld", psname, id);
> +		sprintf(name, "powerpc-common-%s-%lld-%lld", psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_UNKNOWN:
> -		sprintf(name, "unknown-%s-%lld", psname, id);
> +		sprintf(name, "unknown-%s-%lld-%lld", psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	default:
> -		sprintf(name, "type%d-%s-%lld", type, psname, id);
> +		sprintf(name, "type%d-%s-%lld-%lld", type, psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	}
> 
> --
> 1.8.4.1
