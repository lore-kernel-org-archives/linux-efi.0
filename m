From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/16] Add the ability to lock down access to the running kernel image
Date: Wed, 16 Nov 2016 22:40:13 +0000
Message-ID: <20774.1479336013@warthog.procyon.org.uk>
References: <20161116222049.hywdxse4hwsrfwjm@pd.tnic> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <147933284407.19316.17886320817060158597.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161116222049.hywdxse4hwsrfwjm@pd.tnic>
Content-ID: <20773.1479336013.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Borislav Petkov <bp@alien8.de> wrote:

> > +EXPORT_SYMBOL(kernel_locked_down);
> 
> Surely
> 
> EXPORT_SYMBOL(kernel_is_locked_down);

Sorry, yes.  Obviously it won't cause a compilation error...

David
