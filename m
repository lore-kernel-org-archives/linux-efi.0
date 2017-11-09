From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 18/27] bpf: Restrict kernel image access functions when the kernel is locked down
Date: Thu, 09 Nov 2017 17:15:04 +0000
Message-ID: <13472.1510247704@warthog.procyon.org.uk>
References: <20171019233105.5ladqpdf2me36j7q@ast-mbp> <20171019221829.7m5nczg3ltqmhzom@ast-mbp> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842476953.7923.18174368926573855810.stgit@warthog.procyon.org.uk> <482.1508453314@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171019233105.5ladqpdf2me36j7q@ast-mbp>
Content-ID: <13471.1510247704.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: dhowells@redhat.com, jlee@suse.com, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > TBH, I've no idea how bpf does anything, so I can't say whether this is
> > better, overkill or insufficient.
> 
> ok. To make it clear:
> Nacked-by: Alexei Starovoitov <ast@kernel.org>
> For the current patch.
> Unnecessary checks for no good reason in performance critical
> functions are not acceptable.

They aren't unnecessary checks.

Can you please suggest if there's some way more suitable than just killing bpf
entirely?  I don't know the code, and I presume you do.

David
