import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent implements OnInit {
  title = 'angular-app';

  constructor(private http: HttpClient) {}

  ngOnInit() {
    this.http
      .get<any>('http://localhost:3000/data')
      .subscribe((data) => {
        this.title = data.total;
      });
  }
}
