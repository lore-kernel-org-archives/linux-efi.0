From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 26/30] Lock down ftrace
Date: Fri, 10 Nov 2017 11:23:52 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1711101122190.32604@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1711101114410.32604@cbobk.fhfr.pm> <alpine.LRH.2.00.1711101021440.24296@gjva.wvxbf.pm> <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk> <151024883613.28329.14808632296386937974.stgit@warthog.procyon.org.uk>
 <27323.1510308432@warthog.procyon.org.uk> <27646.1510309304@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <27646.1510309304@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, Steven Rostedt <rostedt@goodmis.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 10 Nov 2017, David Howells wrote:

> That would be fine by me.  I have a patch that locks down kprobes in this
> series.  

Which AFAICS renders locking down ftrace as-is unnecessary ...

> Steven says that ftrace might acquire the ability to dump registers in 
> the future.

... and even if that happens, locking down only that particular feature of 
ftrace would be needed.

Thanks,

-- 
Jiri Kosina
SUSE Labs

