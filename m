From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs and dma changed
Date: Fri, 25 Nov 2016 14:49:06 +0000
Message-ID: <7958.1480085346@warthog.procyon.org.uk>
References: <20161124201939.GA3782@isilmar-4.linta.de> <20161123192143.GA482@light.dominikbrodowski.net> <20161122061233.GA4762@light.dominikbrodowski.net> <20161116222731.563fb85e@lxorguk.ukuu.org.uk> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <26173.1479769852@warthog.procyon.org.uk> <8342.1479905906@warthog.procyon.org.uk> <30473.1480008885@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161124201939.GA3782@isilmar-4.linta.de>
Content-ID: <7957.1480085346.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk
List-Id: linux-efi@vger.kernel.org

Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> For most cases, request_firmware() is being used -- for some rare cases,
> however, this alternative interface is provided for. It should be pretty
> safe nowadays to make pccard_cis_attr read-only (and who uses PCMCIA
> nowadays anyway?).

Have a look at the top patch here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=efi-lock-down

David
