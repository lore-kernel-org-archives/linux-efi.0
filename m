From: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Draft manpage explaining kernel lockdown
Date: Thu, 05 Oct 2017 13:07:10 +0200
Message-ID: <1507201630.2387.16.camel@sipsolutions.net>
References: <7969.1507201224@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7969.1507201224@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, mtk.manpages@gmail.com
Cc: mcgrof@kernel.org, linux-man@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-10-05 at 12:00 +0100, David Howells wrote:
> 
> Only validly signed wifi databases may be use.

We don't even have this yet, and when we do, we want this to be the
case for typical configurations regardless of lockdown.

johannes
