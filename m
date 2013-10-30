From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH 2/2] pstore: Differentiating names by adding count and
 timestamp
Date: Wed, 30 Oct 2013 14:38:13 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D38B4@USINDEM103.corp.hds.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
 <1383126294-28793-3-git-send-email-cxie@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383126294-28793-3-git-send-email-cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org" <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



> -----Original Message-----
> From: Madper Xie [mailto:cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Wednesday, October 30, 2013 5:45 AM
> To: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org; ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org; anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org; Seiji Aguchi
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Madper Xie
> Subject: [PATCH 2/2] pstore: Differentiating names by adding count and timestamp
> 
> From: Madper Xie <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> pstore denominates dumped file as type-psname-id. it makes many file have
> the same name if there are many entries in backend have the same id.
> So adding count and timestamp to file name for differentiating.
> 
> Signed-off-by: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It should be tested by other drivers as well..
But, looks good to me.
Acked-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>

> ---
>  fs/pstore/inode.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index 0ae994c..36b502f 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -285,7 +285,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>  	int			rc = 0;
>  	char			name[PSTORE_NAMELEN];
>  	struct pstore_private	*private, *pos;
> -	unsigned long		flags;
> +	unsigned long		flags, timestamp;
> 
>  	spin_lock_irqsave(&allpstore_lock, flags);
>  	list_for_each_entry(pos, &allpstore, list) {
> @@ -316,35 +316,42 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>  	private->count = count;
>  	private->psi = psi;
>  	memcpy(&private->time, &time, sizeof(struct timespec));
> +	timestamp = time.tv_sec;
> 
>  	switch (type) {
>  	case PSTORE_TYPE_DMESG:
> -		sprintf(name, "dmesg-%s-%lld%s", psname, id,
> -						compressed ? ".enc.z" : "");
> +		sprintf(name, "dmesg-%s-%lld-%d-%ld%s", psname, id, count,
> +			timestamp, compressed ? ".enc.z" : "");
>  		break;
>  	case PSTORE_TYPE_CONSOLE:
> -		sprintf(name, "console-%s", psname);
> +		sprintf(name, "console-%s-%d-%ld", psname, count, timestamp);
>  		break;
>  	case PSTORE_TYPE_FTRACE:
> -		sprintf(name, "ftrace-%s", psname);
> +		sprintf(name, "ftrace-%s-%d-%ld", psname, count, timestamp);
>  		break;
>  	case PSTORE_TYPE_MCE:
> -		sprintf(name, "mce-%s-%lld", psname, id);
> +		sprintf(name, "mce-%s-%lld-%d-%ld", psname, id, count,
> +			timestamp);
>  		break;
>  	case PSTORE_TYPE_PPC_RTAS:
> -		sprintf(name, "rtas-%s-%lld", psname, id);
> +		sprintf(name, "rtas-%s-%lld-%d-%ld", psname, id, count,
> +			timestamp);
>  		break;
>  	case PSTORE_TYPE_PPC_OF:
> -		sprintf(name, "powerpc-ofw-%s-%lld", psname, id);
> +		sprintf(name, "powerpc-ofw-%s-%lld-%d-%ld", psname, id, count,
> +			timestamp);
>  		break;
>  	case PSTORE_TYPE_PPC_COMMON:
> -		sprintf(name, "powerpc-common-%s-%lld", psname, id);
> +		sprintf(name, "powerpc-common-%s-%lld-%d-%ld", psname, id,
> +			count, timestamp);
>  		break;
>  	case PSTORE_TYPE_UNKNOWN:
> -		sprintf(name, "unknown-%s-%lld", psname, id);
> +		sprintf(name, "unknown-%s-%lld-%d-%ld", psname, id, count,
> +			timestamp);
>  		break;
>  	default:
> -		sprintf(name, "type%d-%s-%lld", type, psname, id);
> +		sprintf(name, "type%d-%s-%lld-%d-%ld", type, psname, id, count,
> +			timestamp);
>  		break;
>  	}
> 
> --
> 1.8.4.2
