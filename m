From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/6] x86/efi: Allow invocation of arbitrary runtime services
Date: Tue, 22 Nov 2016 14:17:00 +0000
Message-ID: <27422.1479824220@warthog.procyon.org.uk>
References: <20161122102018.GB1552@wunner.de> <20161117123731.GA11573@wunner.de> <147977469914.6360.17194649697208113702.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161122102018.GB1552@wunner.de>
Content-ID: <27421.1479824220.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: dhowells@redhat.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Lukas Wunner <lukas@wunner.de> wrote:

> Small nit, checkpatch usually complains that this should be written as
> 12-character SHA-1 followed by the commit subject, i.e.
> 
> 0a637ee61247 ("x86/efi: Allow invocation of arbitrary boot services")

In this case, checkpatch is wrong.

David
