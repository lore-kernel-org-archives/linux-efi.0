From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH] block: partitions: efi: Always check for alternative GPT
 at end of drive
Date: Tue, 26 Apr 2016 11:10:18 -0700
Message-ID: <20160426181018.GA16601@linux-uzut.site>
References: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
 <571F7D6D.8020209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571F7D6D.8020209-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Austin S. Hemmelgarn" <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Apr 2016, Austin S. Hemmelgarn wrote:

>At the absolute minimum, we should be logging (at least at a warning 
>level) that we had to fall back the the backup GPT.  If somebody is 
>dealing with a disk that had a torn write to the primary GPT, that's 
>one thing, but this could also be caused by any number of other 
>problems (hardware issues, malicious intent, etc), and we need to log 
>that we detected corrupted data.

We already complain about corrupted primary gpt (at a warn level), and
there's also plenty of verbosity about differences between primary and
backup (see compare_gpts()), or are you referring to something else?

Thanks,
Davidlohr
